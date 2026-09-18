package kr.or.oti.mapper;

import java.util.List;

import kr.or.oti.domain.CafeVO;

public interface CafeMapper {

	List<CafeVO> selectAll();
	
	CafeVO selectOne(Long cafeId);
	
	int insertOne(CafeVO cafeVO);
	
	int updateOne(CafeVO cafeVO);
	
	int deleteOne(Long cafeId);
}
