package kr.or.oti.service;

import java.util.List;

import kr.or.oti.dto.CafeBoardDTO;

public interface CafeBoardService {

	List<CafeBoardDTO> getList(Long cafeId);
	
	CafeBoardDTO get(Long cafeId, Long cafeBoardId);
	
	Long register(CafeBoardDTO cafeBoardDTO);
	
	void modify(CafeBoardDTO cafeBoardDTO);

	void remove(
	    Long cafeId,
	    Long cafeBoardId
	);
}
