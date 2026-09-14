package kr.or.oti.mapper;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.MemberAuthVO;
import kr.or.oti.domain.MemberVO;

public interface MemberMapper {

	MemberVO selectOne(@Param("username") String username);
	
	int selectUsernameCount(String username);
	
	int insertOne(MemberVO memberVO);
	
	int insertAuthority(MemberAuthVO memberAuthVO);
}
