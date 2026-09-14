package kr.or.oti.service;

import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.PageRequestDTO;
import kr.or.oti.dto.PageResponseDTO;

public interface BoardService {
	PageResponseDTO<BoardDTO> getList(PageRequestDTO pageRequestDTO);
	BoardDTO get(Long bno); 
	void register(BoardDTO boardDTO);
	void modify(BoardDTO boardDTO);
	void remove(Long bno);
}
