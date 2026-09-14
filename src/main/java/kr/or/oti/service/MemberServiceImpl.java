package kr.or.oti.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.oti.domain.MemberAuthVO;
import kr.or.oti.domain.MemberRole;
import kr.or.oti.domain.MemberVO;
import kr.or.oti.dto.MemberDTO;
import kr.or.oti.exception.DuplicateUsernameException;
import kr.or.oti.exception.PasswordMismatchException;
import kr.or.oti.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {
	
	private final MemberMapper memberMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	@Override
	public MemberDTO get(String username) {
		return VOtoDTO(memberMapper.selectOne(username));
	}
	
	@Transactional
	@Override
	public void register(MemberDTO memberDTO) {
		
		if(memberMapper.selectUsernameCount(memberDTO.getUsername()) > 0) {
			throw new DuplicateUsernameException("이미 사용 중인 아이디입니다.");
		}
		
		if(!memberDTO.getPassword().equals(memberDTO.getPasswordConfirm())) {
			throw new PasswordMismatchException("비밀번호가 일치하지 않습니다.");
		}
		
		memberMapper.insertOne(DTOtoVO(memberDTO));
		
		
		memberMapper.insertAuthority(MemberAuthVO.builder()
				.username(memberDTO.getUsername())
				.authority(MemberRole.ROLE_USER)
				.build());
				
	}
	
	public MemberDTO VOtoDTO(MemberVO memberVO) {
		return MemberDTO.builder()
				.username(memberVO.getUsername())
				.password(memberVO.getPassword())
				.build();
	}
	
	public MemberVO DTOtoVO(MemberDTO memberDTO) {
		return MemberVO.builder()
				.username(memberDTO.getUsername())
				.password(passwordEncoder.encode(memberDTO.getPassword()))
				.build();
	}
}
