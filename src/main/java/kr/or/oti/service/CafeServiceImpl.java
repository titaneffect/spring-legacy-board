package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.oti.domain.CafeMemberVO;
import kr.or.oti.domain.CafeRole;
import kr.or.oti.domain.CafeVO;
import kr.or.oti.dto.CafeDTO;
import kr.or.oti.exception.CafeNotFoundException;
import kr.or.oti.mapper.CafeMapper;
import kr.or.oti.mapper.CafeMemberMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CafeServiceImpl implements CafeService{
	
	private final CafeMapper cafeMapper;
	private final CafeMemberMapper cafeMemberMapper;

	@Override
	public List<CafeDTO> getList(){
		return cafeMapper.selectAll()
					.stream()
					.map(this::VOtoDTO)
					.collect(Collectors.toList());
	}
	
	@Override
	public CafeDTO get(Long cafeId) {
		CafeVO cafeVO = cafeMapper.selectOne(cafeId);
		
		if(cafeVO == null) {
			throw new CafeNotFoundException(cafeId);
		}
		
		return VOtoDTO(cafeVO);
	}
	
	@Override
	@Transactional
	public Long register(CafeDTO cafeDTO, String username) {
		// 1. DTO를 카페 VO로 변환한다.
		CafeVO cafeVO = CafeVO.builder()
							.cafeName(cafeDTO.getCafeName())
							.description(cafeDTO.getDescription())
							.ownerUsername(username)
							.build();
		
		// 2. 카페를 등록한다.
		int cafeResult = cafeMapper.insertOne(cafeVO);
		
		if(cafeResult != 1) {
			throw new IllegalStateException("카페 등록에 실패했습니다.");
		}
		
		// selectKey가 cafeVO에 저장한 PK
		Long cafeId = cafeVO.getCafeId();
		
		// 3. 카페 소유자를 owner로 등록한다.
		CafeMemberVO owner = CafeMemberVO.builder()
									.cafeId(cafeId)
									.memberUsername(username)
									.cafeRole(CafeRole.OWNER)
									.build();
		
		int ownerResult = cafeMemberMapper.insertOne(owner);
		
		if(ownerResult != 1) {
			throw new IllegalStateException("카페 소유자 등록에 실패했습니다.");
		}
		
		// 4. Controller에서 상세 페이지로 이동할 때 사용할 카페 번호
		return cafeId;
	}
	
	@Override
	public void modify(CafeDTO cafeDTO) {
		CafeVO cafeVO = CafeVO.builder()
							.cafeId(cafeDTO.getCafeId())
							.cafeName(cafeDTO.getCafeName())
							.description(cafeDTO.getDescription())
							.build();
		
		int result = cafeMapper.updateOne(cafeVO);
		
		if(result != 1) {
			throw new CafeNotFoundException(cafeDTO.getCafeId());
		}
	}
	
	@Override
	public void remove(Long cafeId) {
		int result = cafeMapper.deleteOne(cafeId);
		
		if(result != 1) {
			throw new CafeNotFoundException(cafeId);
		}
	}
	
	private CafeDTO VOtoDTO(CafeVO cafeVO) {
		return CafeDTO.builder()
					.cafeId(cafeVO.getCafeId())
					.cafeName(cafeVO.getCafeName())
					.description(cafeVO.getDescription())
					.ownerUsername(cafeVO.getOwnerUsername())
					.status(cafeVO.getStatus())
					.createdAt(cafeVO.getCreatedAt())
					.updatedAt(cafeVO.getUpdatedAt())
					.build();
	}
}
