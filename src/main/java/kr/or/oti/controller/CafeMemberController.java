package kr.or.oti.controller;

import java.security.Principal;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.oti.dto.CafeDTO;
import kr.or.oti.service.CafeMemberService;
import kr.or.oti.service.CafeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/cafe/{cafeId:\\d+}/member")
@RequiredArgsConstructor
public class CafeMemberController {

	private final CafeService cafeService;
	private final CafeMemberService cafeMemberService;
	
	@GetMapping
	public String list(@PathVariable("cafeId")Long cafeId, Principal principal, Model model) {
		CafeDTO cafeDTO = cafeService.get(cafeId);
		
		if(!principal.getName().equals(cafeDTO.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 회원을 관리할 수 있습니다.");
		}
		
		model.addAttribute("cafe", cafeDTO);
		model.addAttribute("memberList", cafeMemberService.getList(cafeId));
		
		return "cafe/member/list";
	}
}
