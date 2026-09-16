package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import kr.or.oti.domain.BoardAttachVO;
import kr.or.oti.dto.BoardAttachDTO;
import kr.or.oti.mapper.BoardAttachMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardAttachServiceImpl implements BoardAttachService {
	
	private final BoardAttachMapper boardAttachMapper;
	
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
	
	/*
	 * @Override public void upload(BoardAttachDTO boardAttachDTO) {
	 * boardAttachMapper.insertOne(DTOtoVO(boardAttachDTO)); }
	 */
	
	public BoardAttachDTO VOtoDTO(BoardAttachVO boardAttachVO) {
		return BoardAttachDTO.builder()
				.ano(boardAttachVO.getAno())
				.bno(boardAttachVO.getBno())
				.fileName(boardAttachVO.getFileName())
				.fileSize(boardAttachVO.getFileSize())
				.contentType(boardAttachVO.getContentType())
				.regDate(boardAttachVO.getRegDate())
				.build();
	}
	
	public BoardAttachVO DTOtoVO(BoardAttachDTO boardAttachDTO) {
		return BoardAttachVO.builder()
				.ano(boardAttachDTO.getAno())
				.bno(boardAttachDTO.getBno())
				.fileName(boardAttachDTO.getFileName())
				.fileSize(boardAttachDTO.getFileSize())
				.contentType(boardAttachDTO.getContentType())
				.regDate(boardAttachDTO.getRegDate())
				.build();
	}
}
