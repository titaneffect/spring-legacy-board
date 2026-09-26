package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import kr.or.oti.domain.CafeMemberStatus;
import kr.or.oti.domain.CafeMemberVO;
import kr.or.oti.domain.CafeRole;
import kr.or.oti.dto.CafeMemberDTO;
import kr.or.oti.mapper.CafeMemberMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CafeMemberServiceImpl implements CafeMemberService{

	private final CafeMemberMapper cafeMemberMapper;
	
	@Override
	public List<CafeMemberDTO> getList(Long cafeId){
		return cafeMemberMapper.selectByCafeId(cafeId)
				.stream()
				.map(this::VOtoDTO)
				.collect(Collectors.toList());
	}
	
	@Override
	public CafeMemberDTO get(Long cafeId, String memberUsername) {
		CafeMemberVO cafeMemberVO = cafeMemberMapper.selectOne(cafeId, memberUsername);
		
		if(cafeMemberVO == null) {
			return null;
		}
		
		return VOtoDTO(cafeMemberVO);
	}
	
	@Override
	public CafeMemberDTO getIncludingInactive(Long cafeId, String memberUsername) {
	    CafeMemberVO member =
	            cafeMemberMapper.selectOneAllStatus(cafeId, memberUsername);

	    return member == null ? null : VOtoDTO(member);
	}
	
	@Override
	public void join(Long cafeId, String username) {
		// 일반 회원 가입 신청
		
		CafeMemberVO existingMember = cafeMemberMapper.selectOneAllStatus(cafeId, username);
		
		// 가입 기록 자체가 없으면 최초 INSERT
		if(existingMember == null) {
			CafeMemberVO cafeMemberVO = CafeMemberVO.builder()
											.cafeId(cafeId)
											.memberUsername(username)
											.cafeRole(CafeRole.MEMBER)
											.status(CafeMemberStatus.PENDING)
											.build();
			
			int result = cafeMemberMapper.insertOne(cafeMemberVO);
			
			if(result != 1) {
				throw new IllegalStateException("카페 가입 신청에 실패했습니다.");
			}
			
			return;
		}
		
		// 현재 활동 중인 회원
		if(existingMember.getStatus() == CafeMemberStatus.ACTIVE) {
			throw new IllegalStateException("이미 가입한 카페입니다.");
		}
		
		// 자진 탈퇴한 회원은 기존 행을 복구
		if(existingMember.getStatus() == CafeMemberStatus.WITHDRAWN
				|| existingMember.getStatus() == CafeMemberStatus.REJECTED) {
			
			int result = cafeMemberMapper.reactivate(cafeId, username);
			
			if(result != 1) {
				throw new IllegalStateException("카페 재가입 신청에 실패했습니다.");
			}
			
			return;
		}
		
		// 강퇴된 회원은 재가입 불가
		if(existingMember.getStatus() == CafeMemberStatus.BANNED) {
			throw new AccessDeniedException("강퇴된 회원은 카페에 재가입할 수 없습니다.");
		}
		
		// 가입 승인 대기 중인 경우
		if(existingMember.getStatus() == CafeMemberStatus.PENDING) {
			throw new IllegalStateException("카페 가입 승인 대기 중입니다.");
		}
		
		throw new IllegalStateException("처리할 수 없는 회원 상태입니다.");
		
	}
	
	@Override
	public void approve(Long cafeId, String targetUsername,
	                    String requesterUsername) {
	    validatePendingRequest(cafeId, targetUsername, requesterUsername);

	    if (cafeMemberMapper.approve(cafeId, targetUsername) != 1) {
	        throw new IllegalStateException("가입 승인에 실패했습니다.");
	    }
	}

	@Override
	public void reject(Long cafeId, String targetUsername,
	                   String requesterUsername) {
	    validatePendingRequest(cafeId, targetUsername, requesterUsername);

	    if (cafeMemberMapper.reject(cafeId, targetUsername) != 1) {
	        throw new IllegalStateException("가입 거절에 실패했습니다.");
	    }
	}

	private void validatePendingRequest(Long cafeId, String targetUsername,
	                                    String requesterUsername) {
	    CafeMemberVO requester =
	            cafeMemberMapper.selectOne(cafeId, requesterUsername);

	    if (requester == null || requester.getCafeRole() != CafeRole.OWNER) {
	        throw new AccessDeniedException(
	                "카페 소유자만 가입 신청을 처리할 수 있습니다.");
	    }

	    // selectOne은 ACTIVE만 조회하므로 신청자는 전체 상태 조회를 사용
	    CafeMemberVO target =
	            cafeMemberMapper.selectOneAllStatus(cafeId, targetUsername);

	    if (target == null || target.getStatus() != CafeMemberStatus.PENDING) {
	        throw new IllegalStateException("승인 대기 중인 가입 신청이 아닙니다.");
	    }
	}
	
	@Override
	public void withdraw(Long cafeId, String username) {
		CafeMemberVO cafeMemberVO = cafeMemberMapper.selectOne(cafeId, username);
		
		if(cafeMemberVO == null) {
			throw new IllegalStateException("가입한 카페 회원이 아닙니다.");
		}
		
		if(cafeMemberVO.getCafeRole() == CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유자는 탈퇴할 수 없습니다.");
		}
		
		int result = cafeMemberMapper.withdraw(cafeId, username);
		
		if(result != 1) {
			throw new IllegalStateException("카페 탈퇴에 실패했습니다.");
		}
	}
	
	@Override
	public void ban(Long cafeId, String targetUsername, String requesterUsername) {
		// 강퇴를 요청한 사용자
		CafeMemberVO requester = cafeMemberMapper.selectOne(cafeId, requesterUsername);
		
		if(requester == null || requester.getCafeRole() != CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유자만 회원을 강퇴할 수 있습니다.");
		}
		
		// 강퇴 대상 회원
		CafeMemberVO target = cafeMemberMapper.selectOne(cafeId, targetUsername);
		
		if(target == null) {
			throw new IllegalStateException("해당 카페 회원을 찾을 수 없습니다.");
		}
		
		if(target.getCafeRole() == CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유자는 강퇴할 수 없습니다.");
		}
		
		int result = cafeMemberMapper.ban(cafeId, targetUsername);
		
		if(result != 1) {
			throw new IllegalStateException("카페 회원 강퇴에 실패했습니다.");
		}
	}
	
	@Override
	public void unban(Long cafeId, String targetUsername, String requesterUsername) {
		CafeMemberVO requester = cafeMemberMapper.selectOne(cafeId, requesterUsername);
		
		if(requester == null || requester.getCafeRole() != CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유자만 강퇴를 해제할 수 있습니다.");
		}
		
		CafeMemberVO target = cafeMemberMapper.selectOneAllStatus(cafeId, targetUsername);
		
		if(target == null) {
			throw new IllegalStateException("해당 카페 회원을 찾을 수 없습니다.");
		}
		
		if(target.getStatus() != CafeMemberStatus.BANNED) {
			throw new IllegalStateException("강퇴된 회원이 아닙니다.");
		}
		
		int result = cafeMemberMapper.unban(cafeId, targetUsername);
		
		if(result != 1) {
			throw new IllegalStateException("강퇴 해제에 실패했습니다.");
		}
	}
	
	@Override
	public void changeRole(Long cafeId, String targetUsername, CafeRole newRole, 
			String requesterUsername) {
		
		// 역할 변경을 요청한 사용자 조회
		CafeMemberVO requester = cafeMemberMapper.selectOne(cafeId, requesterUsername);
		
		// 해당 카페 OWNER인지 확인
		if(requester == null || requester.getCafeRole() != CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유주만 회원 역할을 변경할 수 있습니다.");
		}
		
		// 변경 가능한 역할인지 확인
		if(newRole != CafeRole.MEMBER && newRole != CafeRole.MANAGER) {
			throw new AccessDeniedException("변경할 수 없는 카페 역할입니다.");
		}
		
		// 역할을 변경할 대상 회원 조회
		CafeMemberVO target = cafeMemberMapper.selectOne(cafeId, targetUsername);
		
		if(target == null) {
			throw new IllegalArgumentException("해당 카페 회원을 찾을 수 없습니다.");
		}
		
		// OWNER 역할 보호
		if(target.getCafeRole() == CafeRole.OWNER) {
			throw new AccessDeniedException("카페 소유자의 역할은 변경할 수 없습니다.");
		}
		
		int result = cafeMemberMapper.updateRole(cafeId, targetUsername, newRole);
		
		if(result != 1) {
			throw new IllegalStateException("카페 회원 역할 변경에 실패했습니다.");
		}
			
	}
	
	private CafeMemberDTO VOtoDTO(CafeMemberVO cafeMemberVO) {
		return CafeMemberDTO.builder()
				.cafeMemberId(cafeMemberVO.getCafeMemberId())
				.cafeId(cafeMemberVO.getCafeId())
				.memberUsername(cafeMemberVO.getMemberUsername())
				.cafeRole(cafeMemberVO.getCafeRole())
				.status(cafeMemberVO.getStatus())
				.joinedAt(cafeMemberVO.getJoinedAt())
				.build();
	}
}
