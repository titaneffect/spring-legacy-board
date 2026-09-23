package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.domain.AttachUsage;
import kr.or.oti.domain.BoardAttachVO;
import kr.or.oti.dto.BoardAttachDTO;
import kr.or.oti.mapper.BoardAttachMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardAttachServiceImpl implements BoardAttachService {
	
	private final BoardAttachMapper boardAttachMapper;
	private final FileStorageService fileStorageService;
	
	@Override
	public List<BoardAttachDTO> getList(Long bno){
		return boardAttachMapper.selectByBnoAndUsage(bno, AttachUsage.FILE)
				.stream()
				.map(this::VOtoDTO)
				.collect(Collectors.toList());
	}
	
	@Override
	public BoardAttachDTO get(Long ano) {
		BoardAttachVO attach = boardAttachMapper.selectOne(ano);
		
		//VOtoDTO(null) -> NullPointerException
		if(attach == null) {
			return null;
		}
		return VOtoDTO(attach);
	}
	
	@Override
	public Long register(Long bno, MultipartFile uploadFile,
			AttachUsage attachUsage) {
		
		//1. 파일을 디스크에 저장하고
		// 저장 정보를 VO로 반환 받는다.
		BoardAttachVO attach = fileStorageService.store(uploadFile);
		
		//2. 어느 게시판의 첨부파일인지 설정한다.
		attach.setBno(bno);
		attach.setAttachUsage(attachUsage);
		
		//3. 첨부파일 정보를 DB에 저장한다.
		boardAttachMapper.insertOne(attach);
		
		return attach.getAno();
	}
	
	@Override
	@Transactional
	public void remove(Long bno, Long ano) {
		// Mapper 조회 -> VO -> DTO 변환
		BoardAttachDTO boardAttachDTO = get(ano);
		
		if(boardAttachDTO == null) {
			throw new IllegalStateException("첨부파일을 찾을 수 없습니다.");
		}
		
		if(!boardAttachDTO.getBno().equals(bno)) {
			throw new AccessDeniedException("해당 게시글의 첨부파일이 아닙니다.");
		}
		
		int result = boardAttachMapper.deleteOne(ano);
		
		if(result != 1) {
			throw new IllegalStateException("첨부파일 삭제에 실패했습니다.");
		}
		
		fileStorageService.delete(boardAttachDTO);
	}
	
	@Override
	@Transactional
	public void removeAll(Long bno) {
		List<BoardAttachDTO> attachList = boardAttachMapper.selectByBno(bno)
										                .stream()
										                .map(this::VOtoDTO)
										                .collect(Collectors.toList());
		
		for(BoardAttachDTO attach : attachList) {
			int result = boardAttachMapper.deleteOne(attach.getAno());
			
			if(result != 1) {
				throw new IllegalStateException("첨부파일 삭제에 실패했습니다.");
			}
			
			fileStorageService.delete(attach);
		}
	}
	
	@Override
	public String registerContentImages(
	        Long bno,
	        String content,
	        List<MultipartFile> contentImages,
	        List<String> contentImageTokens) {
		
		if(contentImages == null || contentImages.isEmpty()) {
			return content;
		}
		
		if(contentImageTokens == null 
				|| contentImages.size() != contentImageTokens.size()) {
			throw new IllegalStateException("본문 이미지 정보가 올바르지 않습니다.");
		}
		
		String updatedContent = content;

	    for (int i = 0; i < contentImages.size(); i++) {

	        MultipartFile contentImage = contentImages.get(i);

	        String token = contentImageTokens.get(i);

	        if (contentImage.isEmpty()) {
	            continue;
	        }

	        if (token == null || !token.matches("content-image-[0-9]+-[0-9]+")) {
	            throw new IllegalArgumentException("잘못된 본문 이미지 토큰입니다.");
	        }

	        String contentType = contentImage.getContentType();

	        boolean allowedImageType =
	                "image/png".equals(contentType)
	                || "image/jpeg".equals(contentType)
	                || "image/gif".equals(contentType)
	                || "image/webp".equals(contentType);

	        if (!allowedImageType) {
	            throw new IllegalArgumentException(
	                "PNG, JPEG, GIF, WEBP 이미지만 "
	                + "본문에 삽입할 수 있습니다."
	            );
	        }

	        String pendingPath = "/pending-content-image/" + token;

	        /*
	         * 에디터에서 이미지를 지웠다면
	         * 해당 파일도 저장하지 않는다.
	         */
	        if (!updatedContent.contains(pendingPath)) {
	            continue;
	        }

	        Long ano = register(bno, contentImage, AttachUsage.CONTENT_IMAGE);

	        String storedPath = "/attachments/" + ano + "/view";

	        updatedContent = updatedContent.replace(pendingPath, storedPath);
	    }

	    return updatedContent;
	}
	
	@Override
	@Transactional
	public void removeUnusedContentImages(Long bno, String content) {
		String currentContent = content == null ? "" : content;
	
		List<BoardAttachDTO> contentImageList = boardAttachMapper.selectByBnoAndUsage(
														bno, 
														AttachUsage.CONTENT_IMAGE
													)
													.stream()
													.map(this::VOtoDTO)
													.collect(Collectors.toList());
		
		for(BoardAttachDTO contentImage : contentImageList) {
			String imagePath = "/attachments/" + contentImage.getAno() + "/view";
		
			/*
	         * 수정된 본문에 이미지 경로가 없다면
	         * 더 이상 사용하지 않는 본문 이미지이다.
	         */
	        if (!currentContent.contains(imagePath)) {
	            remove(bno, contentImage.getAno());
	        }
		}
	}
	
	private BoardAttachDTO VOtoDTO(BoardAttachVO boardAttachVO) {
		return BoardAttachDTO.builder()
				.ano(boardAttachVO.getAno())
				.bno(boardAttachVO.getBno())
				.uuid(boardAttachVO.getUuid())
				.fileName(boardAttachVO.getFileName())
				.uploadPath(boardAttachVO.getUploadPath())
				.fileSize(boardAttachVO.getFileSize())
				.contentType(boardAttachVO.getContentType())
				.attachUsage(boardAttachVO.getAttachUsage())
				.regDate(boardAttachVO.getRegDate())
				.build();
	}
}
