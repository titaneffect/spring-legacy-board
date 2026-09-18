package kr.or.oti.mapper;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.CafeMemberVO;

public interface CafeMemberMapper {

	CafeMemberVO selectOne(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	int insertOne(CafeMemberVO cafeMemberVO);
}
