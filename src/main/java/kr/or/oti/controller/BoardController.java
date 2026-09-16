package kr.or.oti.controller;

import java.security.Principal;
import java.util.List;

import javax.validation.Valid;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.PageRequestDTO;
import kr.or.oti.service.BoardAttachService;
import kr.or.oti.service.BoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
@Slf4j
public class BoardController {

	private final BoardService boardService;
	private final BoardAttachService boardAttachService;

	@GetMapping("/list")
	public String list(PageRequestDTO pageRequestDTO, Model model) {
		model.addAttribute("pageResponse", boardService.getList(pageRequestDTO));
		model.addAttribute("pageRequest", pageRequestDTO);
		return "board/list";
	}

	@GetMapping("/read")
	public String read(Long bno, PageRequestDTO pageRequestDTO, Model model) {
		model.addAttribute("board", boardService.get(bno));
		model.addAttribute("pageRequest", pageRequestDTO);
		model.addAttribute("attachList", boardAttachService.getList(bno));
		return "board/read";
	}

	@GetMapping("/register")
	public String register() {
		return "board/register";
	}

	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("board") BoardDTO boardDTO,
			BindingResult bindingResult, Model model, Principal principal,
			@RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles) {

		if (bindingResult.hasErrors()) {
			log.info("has errors....");
			model.addAttribute("errors", bindingResult.getAllErrors());
			return "board/register";
		}

		boardDTO.setWriter(principal.getName());
		Long bno = boardService.register(boardDTO);

		if (uploadFiles != null) {
			for (MultipartFile uploadFile : uploadFiles) {
				if (uploadFile.isEmpty()) {
					continue;
				}

				boardAttachService.register(bno, uploadFile);
			}
		}

		return "redirect:/board/read?bno=" + bno;
	}

	@GetMapping("/modify")
	public String modify(Long bno, PageRequestDTO pageRequestDTO, Model model,
			Principal principal) {

		BoardDTO boardDTO = boardService.get(bno);

		if (!principal.getName().equals(boardDTO.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 수정할 수 있습니다.");
		}
		model.addAttribute("board", boardDTO);
		model.addAttribute("pageRequest", pageRequestDTO);
		model.addAttribute("attachList", boardAttachService.getList(bno));
		return "board/modify";
	}

	@PostMapping("/modify")
	public String modify(@Valid @ModelAttribute("board") BoardDTO boardDTO,
			BindingResult bindingResult, PageRequestDTO pageRequestDTO,
			Model model, Principal principal,
			@RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
			@RequestParam(value = "deleteAnoList", required = false) List<Long> deleteAnoList) {

		// 1. DB에 원본 게시글 조회
		BoardDTO savedBoard = boardService.get(boardDTO.getBno());

		// 2. 원래 작성자와 현재 로그인 사용자 비교
		if (!principal.getName().equals(savedBoard.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 수정할 수 있습니다.");
		}

		// 3. 입력값 검증
		if (bindingResult.hasErrors()) {
			log.info("has errors....");
			model.addAttribute("errors", bindingResult.getAllErrors());
			model.addAttribute("pageRequest", pageRequestDTO);
			model.addAttribute("attachList", boardAttachService.getList(boardDTO.getBno()));
			return "board/modify";
		}

		// 4. 작성자가 맞을 때만 수정
		boardService.modify(boardDTO);

		if (uploadFiles != null) {
			for (MultipartFile uploadFile : uploadFiles) {
				if (uploadFile.isEmpty()) {
					continue;
				}

				boardAttachService.register(boardDTO.getBno(), uploadFile);
			}
		}

		if(deleteAnoList != null) { 
			for(Long ano : deleteAnoList) {
				boardAttachService.remove(boardDTO.getBno(), ano);
			} 
		}
		 

		return "redirect:/board/read?bno=" + boardDTO.getBno() + "&" + pageRequestDTO.getLink();
	}

	@PostMapping("/remove")
	public String remove(Long bno, Principal principal) {
		BoardDTO savedBoard = boardService.get(bno);

		if (!principal.getName().equals(savedBoard.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 삭제할 수 있습니다.");
		}
		boardService.remove(bno);
		return "redirect:/board/list";
	}
}
