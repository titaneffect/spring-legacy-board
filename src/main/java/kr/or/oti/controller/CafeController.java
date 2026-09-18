package kr.or.oti.controller;

import java.security.Principal;

import javax.validation.Valid;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.oti.dto.CafeDTO;
import kr.or.oti.service.CafeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/cafe")
@RequiredArgsConstructor
@Slf4j
public class CafeController {

	private final CafeService cafeService;
	
	@GetMapping
	public String list (Model model) {
		model.addAttribute("cafeList", cafeService.getList());
		return "cafe/list";
	}
	
	@GetMapping("/{cafeId:\\d+}")
	public String read(@PathVariable("cafeId")Long cafeId, Model model) {
		model.addAttribute("cafe", cafeService.get(cafeId));
		return "cafe/read";
	}
	
	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("cafe", new CafeDTO());
		return "cafe/register";
	}
	
	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("cafe")CafeDTO cafeDTO,
			BindingResult bindingResult, Principal principal) {
		
		if(bindingResult.hasErrors()) {
			log.info("카페 등록 검증 실패: {}", bindingResult.getAllErrors());
			return "cafe/register";
		}
		
		Long cafeId = cafeService.register(cafeDTO, principal.getName());
		return "redirect:/cafe/" + cafeId;
	}
	
	@GetMapping("/{cafeId:\\d+}/modify")
	public String modify(@PathVariable("cafeId")Long cafeId, Model model,
			Principal principal) {
		
		// DB에서 기존 카페 정보를 조회
		CafeDTO cafeDTO = cafeService.get(cafeId);
		
		// 카페 소유자 확인
		if(!principal.getName().equals(cafeDTO.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 수정할 수 있습니다.");
		}
		
		// 수정 jsp에서 기존 값을 출력할 수 있도록 저장
		model.addAttribute("cafe", cafeDTO);
		return "cafe/modify";
	}
	
	@PostMapping("/{cafeId:\\d+}/modify")
	public String modify(@PathVariable("cafeId")Long cafeId,
			@Valid @ModelAttribute("cafe")CafeDTO cafeDTO,
			BindingResult bindingResult, Principal principal) {
		
		// URL의 카페 번호를 수정 대상 번호로 사용
		cafeDTO.setCafeId(cafeId);
		
		// DB에 저장된 원본 카페 조회
		CafeDTO savedCafe = cafeService.get(cafeId);
		
		// POST 요청에서도 반드시 소유자 재확인
		if(!principal.getName().equals(savedCafe.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 수정할 수 있습니다.");
		}
		
		// 입력값 검증 실패
		if(bindingResult.hasErrors()) {
			log.info("카페 수정 검증 실패: {}", bindingResult.getAllErrors());
			return "cafe/modify";
		}
		
		cafeService.modify(cafeDTO);
		return "redirect:/cafe/" + cafeId;
	}
	
	@PostMapping("/{cafeId:\\d+}/remove")
	public String remove(@PathVariable("cafeId")Long cafeId,
			Principal principal) {
		
		CafeDTO savedCafe = cafeService.get(cafeId);
		
		if(!principal.getName().equals(savedCafe.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 삭제할 수 있습니다.");
		}
		
		cafeService.remove(cafeId);
		return "redirect:/cafe";
	}
}
