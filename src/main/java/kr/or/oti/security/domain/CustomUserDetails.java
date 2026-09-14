package kr.or.oti.security.domain;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import kr.or.oti.domain.MemberVO;

public class CustomUserDetails implements UserDetails {

	private static final long serialVersionUID = 1L;

	private final MemberVO memberVO;

	public CustomUserDetails(MemberVO memberVO) {
		this.memberVO = memberVO;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return memberVO.getAuthList()
				.stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuthority().name()))
				.collect(Collectors.toList());
	}

	@Override
	public String getPassword() {
		return memberVO.getPassword();
	}

	@Override
	public String getUsername() {
		return memberVO.getUsername();
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return memberVO.isEnabled();
	}
}
