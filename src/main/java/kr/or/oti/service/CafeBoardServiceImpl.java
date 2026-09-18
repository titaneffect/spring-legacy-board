package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import kr.or.oti.domain.CafeBoardAccessLevel;
import kr.or.oti.domain.CafeBoardVO;
import kr.or.oti.dto.CafeBoardDTO;
import kr.or.oti.exception.CafeBoardNotFoundException;
import kr.or.oti.mapper.CafeBoardMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CafeBoardServiceImpl implements CafeBoardService{
	
	private final CafeBoardMapper cafeBoardMapper;
	
	@Override
	public List<CafeBoardDTO> getList(Long cafeId){
		return cafeBoardMapper.selectByCafeId(cafeId)
						.stream()
						.map(this::VOtoDTO)
						.collect(Collectors.toList());
	}
	
	@Override
	public CafeBoardDTO get(Long cafeId, Long cafeBoardId) {

	    CafeBoardVO cafeBoardVO = cafeBoardMapper.selectOne(cafeId, cafeBoardId);

	    if (cafeBoardVO == null) {
	        throw new CafeBoardNotFoundException(cafeId, cafeBoardId);
	    }

	    return VOtoDTO(cafeBoardVO);
	}
	
	@Override
	public Long register(CafeBoardDTO cafeBoardDTO) {
		if(cafeBoardDTO.getWriteRole() == CafeBoardAccessLevel.GUEST) {
			throw new IllegalArgumentException("비회원에게 글쓰기 권한을 부여할 수 없습니다.");
		}
		
		CafeBoardVO cafeBoardVO = CafeBoardVO.builder()
									.cafeId(cafeBoardDTO.getCafeId())
									.boardName(cafeBoardDTO.getBoardName())
									.boardType(cafeBoardDTO.getBoardType())
									.readRole(cafeBoardDTO.getReadRole())
									.writeRole(cafeBoardDTO.getWriteRole())
									.displayOrder(cafeBoardDTO.getDisplayOrder())
									.build();
		
		int result = cafeBoardMapper.insertOne(cafeBoardVO);
		
		if(result != 1) {
			throw new IllegalStateException("카페 게시판 등록에 실패했습니다.");
		}
		
		return cafeBoardVO.getCafeBoardId();
	}
	
	@Override
	public void modify(
	        CafeBoardDTO cafeBoardDTO) {

	    if (cafeBoardDTO.getWriteRole()
	            == CafeBoardAccessLevel.GUEST) {

	        throw new IllegalArgumentException(
	            "비회원에게 글쓰기 권한을 부여할 수 없습니다."
	        );
	    }

	    CafeBoardVO cafeBoardVO =
	            CafeBoardVO.builder()
	                .cafeBoardId(
	                    cafeBoardDTO.getCafeBoardId()
	                )
	                .cafeId(
	                    cafeBoardDTO.getCafeId()
	                )
	                .boardName(
	                    cafeBoardDTO.getBoardName()
	                )
	                .boardType(
	                    cafeBoardDTO.getBoardType()
	                )
	                .readRole(
	                    cafeBoardDTO.getReadRole()
	                )
	                .writeRole(
	                    cafeBoardDTO.getWriteRole()
	                )
	                .displayOrder(
	                    cafeBoardDTO.getDisplayOrder()
	                )
	                .build();

	    int result =
	            cafeBoardMapper.updateOne(cafeBoardVO);

	    if (result != 1) {
	        throw new CafeBoardNotFoundException(
	            cafeBoardDTO.getCafeId(),
	            cafeBoardDTO.getCafeBoardId()
	        );
	    }
	}
	
	@Override
	public void remove(
	        Long cafeId,
	        Long cafeBoardId) {

	    int result =
	            cafeBoardMapper.deleteOne(
	                cafeId,
	                cafeBoardId
	            );

	    if (result != 1) {
	        throw new CafeBoardNotFoundException(
	            cafeId,
	            cafeBoardId
	        );
	    }
	}
	
	 private CafeBoardDTO VOtoDTO(CafeBoardVO cafeBoardVO) {
	        return CafeBoardDTO.builder()
	                .cafeBoardId(cafeBoardVO.getCafeBoardId())	                
	                .cafeId(cafeBoardVO.getCafeId())
	                .boardName(cafeBoardVO.getBoardName())
	                .boardType(cafeBoardVO.getBoardType())
	                .readRole(cafeBoardVO.getReadRole())
	                .writeRole(cafeBoardVO.getWriteRole())
	                .displayOrder(cafeBoardVO.getDisplayOrder())
	                .status(cafeBoardVO.getStatus())
	                .createdAt(cafeBoardVO.getCreatedAt())
	                .updatedAt(cafeBoardVO.getUpdatedAt())
	                .build();
    }
}
