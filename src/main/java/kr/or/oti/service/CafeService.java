package kr.or.oti.service;

import java.util.List;

import kr.or.oti.dto.CafeDTO;

public interface CafeService {
	
	List<CafeDTO> getList();
	
	CafeDTO get(Long cafeId);
	
	Long register(CafeDTO cafeDTO, String username);
	
	void modify(CafeDTO cafeDTO);
	
	void remove(Long cafeId);
}
