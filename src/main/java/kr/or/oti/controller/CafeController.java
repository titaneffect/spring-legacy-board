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

import kr.or.oti.domain.CafeBoardAccessLevel;
import kr.or.oti.domain.CafeBoardType;
import kr.or.oti.dto.CafeBoardDTO;
import kr.or.oti.dto.CafeDTO;
import kr.or.oti.service.CafeBoardService;
import kr.or.oti.service.CafeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/cafe")
@RequiredArgsConstructor
@Slf4j
public class CafeController {

	private final CafeService cafeService;
	private final CafeBoardService cafeBoardService;

	@GetMapping
	public String list(Model model) {
		model.addAttribute("cafeList", cafeService.getList());
		return "cafe/list";
	}

	@GetMapping("/{cafeId:\\d+}")
	public String read(@PathVariable("cafeId") Long cafeId, Model model) {
		// 카페가 존재하는지 먼저 확인
		model.addAttribute("cafe", cafeService.get(cafeId));
		model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
		return "cafe/read";
	}

	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("cafe", new CafeDTO());
		return "cafe/register";
	}

	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("cafe") CafeDTO cafeDTO, BindingResult bindingResult,
			Principal principal) {

		if (bindingResult.hasErrors()) {
			log.info("카페 등록 검증 실패: {}", bindingResult.getAllErrors());
			return "cafe/register";
		}

		Long cafeId = cafeService.register(cafeDTO, principal.getName());
		return "redirect:/cafe/" + cafeId;
	}

	@GetMapping("/{cafeId:\\d+}/modify")
	public String modify(@PathVariable("cafeId") Long cafeId, Model model, Principal principal) {

		// DB에서 기존 카페 정보를 조회
		CafeDTO cafeDTO = cafeService.get(cafeId);

		// 카페 소유자 확인
		if (!principal.getName().equals(cafeDTO.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 수정할 수 있습니다.");
		}

		// 수정 jsp에서 기존 값을 출력할 수 있도록 저장
		model.addAttribute("cafe", cafeDTO);
		return "cafe/modify";
	}

	@PostMapping("/{cafeId:\\d+}/modify")
	public String modify(@PathVariable("cafeId") Long cafeId, @Valid @ModelAttribute("cafe") CafeDTO cafeDTO,
			BindingResult bindingResult, Principal principal) {

		// URL의 카페 번호를 수정 대상 번호로 사용
		cafeDTO.setCafeId(cafeId);

		// DB에 저장된 원본 카페 조회
		CafeDTO savedCafe = cafeService.get(cafeId);

		// POST 요청에서도 반드시 소유자 재확인
		if (!principal.getName().equals(savedCafe.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 수정할 수 있습니다.");
		}

		// 입력값 검증 실패
		if (bindingResult.hasErrors()) {
			log.info("카페 수정 검증 실패: {}", bindingResult.getAllErrors());
			return "cafe/modify";
		}

		cafeService.modify(cafeDTO);
		return "redirect:/cafe/" + cafeId;
	}

	@PostMapping("/{cafeId:\\d+}/remove")
	public String remove(@PathVariable("cafeId") Long cafeId, Principal principal) {

		CafeDTO savedCafe = cafeService.get(cafeId);

		if (!principal.getName().equals(savedCafe.getOwnerUsername())) {
			throw new AccessDeniedException("카페 소유자만 삭제할 수 있습니다.");
		}

		cafeService.remove(cafeId);
		return "redirect:/cafe";
	}

	
	
	
	
	@GetMapping("/{cafeId:\\d+}/boards/register")
	public String registerCafeBoard(@PathVariable("cafeId") Long cafeId, Model model, Principal principal) {

		CafeDTO cafeDTO = cafeService.get(cafeId);

		// 현재는 카페 소유자만 게시판 생성 가능
		if (!principal.getName().equals(cafeDTO.getOwnerUsername())) {

			throw new AccessDeniedException("카페 소유자만 게시판을 만들 수 있습니다.");
		}

		CafeBoardDTO cafeBoardDTO = CafeBoardDTO.builder().cafeId(cafeId).boardType(CafeBoardType.GENERAL)
				.readRole(CafeBoardAccessLevel.GUEST).writeRole(CafeBoardAccessLevel.MEMBER).displayOrder(0).build();

		model.addAttribute("cafe", cafeDTO);
		model.addAttribute("cafeBoard", cafeBoardDTO);

		addCafeBoardOptions(model);

		return "cafe/board/register";
	}

	@PostMapping("/{cafeId:\\d+}/boards/register")
	public String registerCafeBoard(@PathVariable("cafeId") Long cafeId,
			@Valid @ModelAttribute("cafeBoard") CafeBoardDTO cafeBoardDTO, BindingResult bindingResult, Model model,
			Principal principal) {

		CafeDTO cafeDTO = cafeService.get(cafeId);

		// POST 요청에서도 소유자 재검사
		if (!principal.getName().equals(cafeDTO.getOwnerUsername())) {

			throw new AccessDeniedException("카페 소유자만 게시판을 만들 수 있습니다.");
		}

		// 수정 대상 카페는 URL 값으로 결정
		cafeBoardDTO.setCafeId(cafeId);

		// 변조 요청으로 GUEST 쓰기를 보낸 경우
		if (cafeBoardDTO.getWriteRole() == CafeBoardAccessLevel.GUEST) {

			bindingResult.rejectValue("writeRole", "guestWriteNotAllowed", "비회원에게 글쓰기 권한을 부여할 수 없습니다.");
		}

		if (bindingResult.hasErrors()) {
			log.info("카페 게시판 등록 검증 실패: {}", bindingResult.getAllErrors());

			model.addAttribute("cafe", cafeDTO);
			addCafeBoardOptions(model);

			return "cafe/board/register";
		}

		cafeBoardService.register(cafeBoardDTO);

		return "redirect:/cafe/" + cafeId;
	}
	
	@GetMapping("/{cafeId:\\d+}/boards/{cafeBoardId:\\d+}/modify")
	public String modifyCafeBoard(
	        @PathVariable("cafeId") Long cafeId,
	        @PathVariable("cafeBoardId")
	        Long cafeBoardId,
	        Model model,
	        Principal principal) {

	    CafeDTO cafeDTO =
	            cafeService.get(cafeId);

	    // 현재는 카페 소유자만 게시판 관리 가능
	    if (!principal.getName()
	            .equals(cafeDTO.getOwnerUsername())) {

	        throw new AccessDeniedException(
	            "카페 소유자만 게시판을 수정할 수 있습니다."
	        );
	    }

	    // 해당 게시판이 해당 카페 소속인지 함께 확인
	    CafeBoardDTO cafeBoardDTO =
	            cafeBoardService.get(
	                cafeId,
	                cafeBoardId
	            );

	    model.addAttribute("cafe", cafeDTO);

	    model.addAttribute(
	        "cafeBoard",
	        cafeBoardDTO
	    );

	    addCafeBoardOptions(model);

	    return "cafe/board/modify";
	}
	
	@PostMapping("/{cafeId:\\d+}/boards/{cafeBoardId:\\d+}/modify")
	public String modifyCafeBoard(
	        @PathVariable("cafeId") Long cafeId,
	        @PathVariable("cafeBoardId")
	        Long cafeBoardId,
	        @Valid
	        @ModelAttribute("cafeBoard")
	        CafeBoardDTO cafeBoardDTO,
	        BindingResult bindingResult,
	        Model model,
	        Principal principal) {

	    CafeDTO cafeDTO =
	            cafeService.get(cafeId);

	    // POST에서도 소유자 재검사
	    if (!principal.getName()
	            .equals(cafeDTO.getOwnerUsername())) {

	        throw new AccessDeniedException(
	            "카페 소유자만 게시판을 수정할 수 있습니다."
	        );
	    }

	    // 수정 대상은 URL 값으로 결정
	    cafeBoardDTO.setCafeId(cafeId);
	    cafeBoardDTO.setCafeBoardId(cafeBoardId);

	    // 게시판이 실제로 해당 카페에 존재하는지 확인
	    cafeBoardService.get(
	        cafeId,
	        cafeBoardId
	    );

	    if (cafeBoardDTO.getWriteRole()
	            == CafeBoardAccessLevel.GUEST) {

	        bindingResult.rejectValue(
	            "writeRole",
	            "guestWriteNotAllowed",
	            "비회원에게 글쓰기 권한을 부여할 수 없습니다."
	        );
	    }

	    if (bindingResult.hasErrors()) {
	        log.info(
	            "카페 게시판 수정 검증 실패: {}",
	            bindingResult.getAllErrors()
	        );

	        model.addAttribute("cafe", cafeDTO);
	        addCafeBoardOptions(model);

	        return "cafe/board/modify";
	    }

	    cafeBoardService.modify(cafeBoardDTO);

	    return "redirect:/cafe/" + cafeId;
	}

	@PostMapping("/{cafeId:\\d+}/boards/{cafeBoardId:\\d+}/remove")
	public String removeCafeBoard(
	        @PathVariable("cafeId") Long cafeId,
	        @PathVariable("cafeBoardId")
	        Long cafeBoardId,
	        Principal principal) {

	    CafeDTO cafeDTO =
	            cafeService.get(cafeId);

	    if (!principal.getName()
	            .equals(cafeDTO.getOwnerUsername())) {

	        throw new AccessDeniedException(
	            "카페 소유자만 게시판을 삭제할 수 있습니다."
	        );
	    }

	    cafeBoardService.remove(
	        cafeId,
	        cafeBoardId
	    );

	    return "redirect:/cafe/" + cafeId;
	}
	
	private void addCafeBoardOptions(Model model) {

		model.addAttribute("boardTypes", CafeBoardType.values());
		model.addAttribute("readLevels", CafeBoardAccessLevel.values());
		model.addAttribute("writeLevels", new CafeBoardAccessLevel[] { CafeBoardAccessLevel.MEMBER,
				CafeBoardAccessLevel.MANAGER, CafeBoardAccessLevel.OWNER });
	}
}
