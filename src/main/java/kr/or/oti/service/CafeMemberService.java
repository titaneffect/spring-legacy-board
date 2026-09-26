package kr.or.oti.service;

import java.util.List;

import kr.or.oti.domain.CafeRole;
import kr.or.oti.dto.CafeMemberDTO;

public interface CafeMemberService {

	List<CafeMemberDTO> getList(Long cafeId);
	
	CafeMemberDTO get(Long cafeId, String memberUsername);
	
	CafeMemberDTO getIncludingInactive(Long cafeId, String memberUsername);
	
	void join(Long cafeId, String username);
	
	void approve(Long cafeId, String targetUsername, String requesterUsername);

	void reject(Long cafeId, String targetUsername, String requesterUsername);
	
	void withdraw(Long cafeId, String username);
	
	void ban(Long cafeId, String targetUsername, String requesterUsername);
	
	void unban(Long cafeId, String targetUsername, String requesterUsername);
	
	void changeRole(Long cafeId, String targetUsername, CafeRole cafeRole, 
			String requesterUsername);
	
}
