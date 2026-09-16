package kr.or.oti.service;

import java.util.List;

import kr.or.oti.dto.BoardAttachDTO;

public interface BoardAttachService {
	
	List<BoardAttachDTO> getList(Long bno);
	
	BoardAttachDTO get(Long ano);
	
	//void upload(BoardAttachDTO boardAttachDTO);

}
