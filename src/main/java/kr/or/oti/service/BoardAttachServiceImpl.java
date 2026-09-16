package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
		return boardAttachMapper.selectByBno(bno)
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
	public void register(Long bno, MultipartFile uploadFile) {
		//1. 파일을 디스크에 저장하고
		// 저장 정보를 VO로 반환 받는다.
		BoardAttachVO attach = fileStorageService.store(uploadFile);
		
		//2. 어느 게시판의 첨부파일인지 설정한다.
		attach.setBno(bno);
		
		//3. 첨부파일 정보를 DB에 저장한다.
		boardAttachMapper.insertOne(attach);
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
		
		if(result == 0) {
			throw new IllegalStateException("첨부파일 삭제에 실패했습니다.");
		}
		
		fileStorageService.delete(boardAttachDTO);
	}
	
	@Override
	@Transactional
	public void removeAll(Long bno) {
		List<BoardAttachDTO> attachList = getList(bno);
		
		for(BoardAttachDTO attach : attachList) {
			int result = boardAttachMapper.deleteOne(attach.getAno());
			
			if(result == 0) {
				throw new IllegalStateException("첨부파일 삭제에 실패했습니다.");
			}
			
			fileStorageService.delete(attach);
		}
	}
	
	public BoardAttachDTO VOtoDTO(BoardAttachVO boardAttachVO) {
		return BoardAttachDTO.builder()
				.ano(boardAttachVO.getAno())
				.bno(boardAttachVO.getBno())
				.uuid(boardAttachVO.getUuid())
				.fileName(boardAttachVO.getFileName())
				.uploadPath(boardAttachVO.getUploadPath())
				.fileSize(boardAttachVO.getFileSize())
				.contentType(boardAttachVO.getContentType())
				.regDate(boardAttachVO.getRegDate())
				.build();
	}
}
