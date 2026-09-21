package kr.or.oti.service;

import org.springframework.stereotype.Service;

import kr.or.oti.domain.CafeBoardAccessLevel;
import kr.or.oti.domain.CafeRole;
import kr.or.oti.dto.CafeMemberDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CafeBoardAccessService {

	private final CafeMemberService cafeMemberService;
	
	public boolean canAccess(Long cafeId, String username,
			CafeBoardAccessLevel requiredLevel) {
		
		if(requiredLevel == CafeBoardAccessLevel.GUEST) {
			return true;
		}
		
		if(username == null) {
			return false;
		}
		
		CafeMemberDTO member = cafeMemberService.get(cafeId, username);
		
		if(member == null) {
			return false;
		}
		
		switch(requiredLevel) {
		case MEMBER:
			return true;
		
		case MANAGER:
			return member.getCafeRole() == CafeRole.MANAGER
				|| member.getCafeRole() == CafeRole.OWNER;
			
		case OWNER:
			return member.getCafeRole() == CafeRole.OWNER;
		
		default:
			return false;
		
		}
	}
}
