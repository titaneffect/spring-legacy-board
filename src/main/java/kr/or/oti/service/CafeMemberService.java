package kr.or.oti.service;

import java.util.List;

import kr.or.oti.dto.CafeMemberDTO;

public interface CafeMemberService {

	List<CafeMemberDTO> getList(Long cafeId);
	
	CafeMemberDTO get(Long cafeId, String memberUsername);
}
