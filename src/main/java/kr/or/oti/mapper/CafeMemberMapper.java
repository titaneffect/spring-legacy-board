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
	
	// WITHDRAWN, BANNED까지 조회
	CafeMemberVO selectOneAllStatus(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	// 회원 탈퇴
	int withdraw(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	// 회원 재가입
	int reactivate(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	// 회원 강퇴
	int ban(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
	
	// 회원 강퇴 해제
	int unban(@Param("cafeId")Long cafeId,
			@Param("memberUsername")String memberUsername);
}
