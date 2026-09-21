package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

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
	public void join(Long cafeId, String username) {
		CafeMemberVO existingMember = cafeMemberMapper.selectOne(cafeId, username);
		
		if(existingMember != null) {
			throw new IllegalStateException("이미 가입한 카페입니다.");
		}
		
		CafeMemberVO cafeMemberVO = CafeMemberVO.builder()
										.cafeId(cafeId)
										.memberUsername(username)
										.cafeRole(CafeRole.MEMBER)
										.build();
		
		int result = cafeMemberMapper.insertOne(cafeMemberVO);
		
		if(result != 1) {
			throw new IllegalStateException("카페 가입에 실패했습니다.");
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
