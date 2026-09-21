package kr.or.oti.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.CafeMemberVO;
import kr.or.oti.domain.CafeRole;

public interface CafeMemberMapper {
	
	List<CafeMemberVO> selectByCafeId(@Param("cafeId")Long cafeId);

	CafeMemberVO selectOne(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	int insertOne(CafeMemberVO cafeMemberVO);
	
	int updateRole(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername,
			@Param("cafeRole")CafeRole cafeRole);
}
