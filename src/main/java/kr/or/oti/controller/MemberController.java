package kr.or.oti.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.oti.dto.MemberDTO;
import kr.or.oti.exception.DuplicateUsernameException;
import kr.or.oti.exception.PasswordMismatchException;
import kr.or.oti.service.MemberService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
	
	private final MemberService memberService;
	
	@GetMapping("/login")
	public String login(Long cafeId, Long cafeBoardId, Long bno, HttpSession session) {
		
		if(cafeId != null && cafeBoardId != null) {
			session.setAttribute("loginReturnCafeId", cafeId);
			session.setAttribute("loginReturnCafeBoardId", cafeBoardId);
			
			if (bno != null) {
				session.setAttribute("loginReturnBno", bno);
			} else {
				session.removeAttribute("loginReturnBno");
			}
		}
		
		return "member/login";
	}
	
	//PostMapping("/login") Controller가 아닌 Spring Security가 처리
	
	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("member", new MemberDTO());
		return "member/register";
	}
	
	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("member") MemberDTO memberDTO, BindingResult bindingResult) {
		// @NotBlank 등의 기본 검증 오류
		if(bindingResult.hasErrors()) {
			return "member/register";
		}
		
		try {
			memberService.register(memberDTO);
			
		} catch (DuplicateUsernameException e) {
			bindingResult.rejectValue("username", "duplicate", e.getMessage());
			
			return "member/register";
			
		} catch (PasswordMismatchException e) {
			bindingResult.rejectValue("passwordConfirm", "mismatch", e.getMessage());
			
			return "member/register";
		}
		
		return "redirect:/member/login?registered";
	}
}
