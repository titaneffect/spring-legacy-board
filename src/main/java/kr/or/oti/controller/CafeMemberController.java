package kr.or.oti.controller;

import java.security.Principal;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.oti.domain.CafeRole;
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
	
	@PostMapping("/join")
	public String join(@PathVariable("cafeId")Long cafeId, Principal principal) {
		// 존재하지 않는 카페라면 404
		cafeService.get(cafeId);
		
		cafeMemberService.join(cafeId, principal.getName());
		
		return "redirect:/cafe/" + cafeId;
	}
	
	@PostMapping("/{memberUsername}/role")
	public String changeRole(@PathVariable("cafeId") Long cafeId,
	        @PathVariable("memberUsername")String memberUsername,
	        @RequestParam("cafeRole")CafeRole cafeRole, Principal principal) {
		
		// 존재하지 않는 카페라면 404
		cafeService.get(cafeId);
		
		cafeMemberService.changeRole(cafeId, memberUsername, cafeRole, principal.getName());

		return "redirect:/cafe/" + cafeId + "/member";
	}
}
