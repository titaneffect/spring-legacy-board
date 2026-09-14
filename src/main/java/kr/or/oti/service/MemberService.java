package kr.or.oti.service;

import kr.or.oti.dto.MemberDTO;

public interface MemberService {
	
	MemberDTO get(String username);
	
	void register(MemberDTO memberDTO);

}
