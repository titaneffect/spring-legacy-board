package kr.or.oti.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.CafeBoardVO;

public interface CafeBoardMapper {
	
	List<CafeBoardVO> selectByCafeId(@Param("cafeId")Long cafeId);
	
	CafeBoardVO selectOne(
		@Param("cafeId")Long cafeId,
		@Param("cafeBoardId")Long cafeBoardId
	);
	
	int insertOne(CafeBoardVO cafeBoardVO);
	
	int updateOne(CafeBoardVO cafeBoardVO);

    int deleteOne(
        @Param("cafeId") Long cafeId,
        @Param("cafeBoardId") Long cafeBoardId
    );

}
