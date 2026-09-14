package kr.or.oti.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.oti.domain.MemberVO;
import kr.or.oti.mapper.MemberMapper;
import kr.or.oti.security.domain.CustomUserDetails;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

	private final MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException {
		MemberVO memberVO = memberMapper.selectOne(username);
		
		if(memberVO == null) {
			throw new UsernameNotFoundException(
				"회원을 찾을 수 없습니다. : " + username
			);
		}
		
		return new CustomUserDetails(memberVO);
	}
}
