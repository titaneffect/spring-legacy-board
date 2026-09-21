package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import kr.or.oti.domain.CafeMemberVO;
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
