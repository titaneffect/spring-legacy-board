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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.CafeBoardDTO;
import kr.or.oti.dto.PageRequestDTO;
import kr.or.oti.exception.BoardNotFoundException;
import kr.or.oti.service.BoardAttachService;
import kr.or.oti.service.BoardService;
import kr.or.oti.service.CafeBoardAccessService;
import kr.or.oti.service.CafeBoardService;
import kr.or.oti.util.BoardHtmlSanitizer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/cafe/{cafeId:\\d+}/board/{cafeBoardId:\\d+}/post")
@RequiredArgsConstructor
@Slf4j
public class BoardController {

	private final BoardService boardService;
	private final BoardAttachService boardAttachService;
	private final CafeBoardService cafeBoardService;
	private final CafeBoardAccessService cafeBoardAccessService;

	@GetMapping
	public String list(
		@PathVariable("cafeId")Long cafeId, @PathVariable("cafeBoardId")Long cafeBoardId,
		PageRequestDTO pageRequestDTO, Principal principal, Model model) {
		
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		String username = principal == null ? null : principal.getName();
		
		boolean canRead = cafeBoardAccessService.canAccess(cafeId, username,
				cafeBoard.getReadRole());
		
		if(!canRead) {
			throw new AccessDeniedException("이 게시판을 조회할 권한이 없습니다.");
		}
		
		boolean canWrite = cafeBoardAccessService.canAccess(cafeId, username,
				cafeBoard.getWriteRole());
		
		model.addAttribute("canWrite", canWrite);
		
		model.addAttribute("pageResponse", boardService.getList(cafeBoardId, pageRequestDTO));
		model.addAttribute("pageRequest", pageRequestDTO);
		model.addAttribute("cafeId", cafeId);
		model.addAttribute("cafeBoard", cafeBoard);
		model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
		
		return "board/list";
	}

	@GetMapping("/{bno:\\d+}")
	public String read(
		@PathVariable("cafeId") Long cafeId, @PathVariable("cafeBoardId") Long cafeBoardId,
	    @PathVariable("bno") Long bno, PageRequestDTO pageRequestDTO,
	    Principal principal, Model model) {
		
		// 게시판이 해당 카페 소속인지 확인
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		String username = principal == null ? null : principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getReadRole())) {
			throw new AccessDeniedException("이 게시글을 조회할 권한이 없습니다.");
		}
		
		BoardDTO boardDTO = boardService.get(bno);
		
		model.addAttribute("safeContent", BoardHtmlSanitizer.sanitize(boardDTO.getContent()));
		
		// 다른 게시판의 글 번호를 URL로 넣는 경우 차단
		if (!cafeBoardId.equals(boardDTO.getCafeBoardId())) {
	        throw new BoardNotFoundException(bno);
	    }
		
		boolean canWrite  = cafeBoardAccessService.
				canAccess(cafeId, username, cafeBoard.getWriteRole());
		
		boolean canModify = canWrite && username != null
				&& username.equals(boardDTO.getWriter());
		
		model.addAttribute("canWrite", canWrite);
		model.addAttribute("canModify", canModify);
		
		model.addAttribute("cafeId", cafeId);
	    model.addAttribute("cafeBoard", cafeBoard);
	    model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
		model.addAttribute("board", boardDTO);
		model.addAttribute("pageRequest", pageRequestDTO);
		model.addAttribute("attachList", boardAttachService.getList(bno));
		
		return "board/read";
	}

	@GetMapping("/register")
	public String register(
			@PathVariable("cafeId")Long cafeId,
			@PathVariable("cafeBoardId")Long cafeBoardId,
			Principal principal, Model model) {
		
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		String username = principal == null ? null : principal.getName();
		
		boolean canWrite  = cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getWriteRole());
			
		if(!canWrite) {
			throw new AccessDeniedException("이 게시판에 글을 작성할 권한이 없습니다.");
		}
				
		model.addAttribute("canWrite", canWrite);
		
		model.addAttribute("cafeId", cafeId);
		model.addAttribute("cafeBoard", cafeBoard);
		model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
		model.addAttribute("board", new BoardDTO());
		
		return "board/register";
	}

	@PostMapping("/register")
	public String register(
			@PathVariable("cafeId") Long cafeId, @PathVariable("cafeBoardId") Long cafeBoardId,
			@Valid @ModelAttribute("board") BoardDTO boardDTO,
			BindingResult bindingResult, Model model, Principal principal,
			@RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles) {

		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		String username = principal == null ? null : principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getWriteRole())) {
			throw new AccessDeniedException("이 게시판에 글을 작성할 권한이 없습니다.");
		}
		
		if (bindingResult.hasErrors()) {
			log.info("has errors....");
			
			model.addAttribute("canWrite", true);
			
			model.addAttribute("errors", bindingResult.getAllErrors());
			model.addAttribute("cafeId", cafeId);
			model.addAttribute("cafeBoard", cafeBoard);
			model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
			
			return "board/register";
		}
		
		boardDTO.setCafeBoardId(cafeBoard.getCafeBoardId());
		boardDTO.setWriter(username);
		
		Long bno = boardService.register(boardDTO);

		if (uploadFiles != null) {
			for (MultipartFile uploadFile : uploadFiles) {
				if (uploadFile.isEmpty()) {
					continue;
				}

				boardAttachService.register(bno, uploadFile);
			}
		}

		return "redirect:/cafe/" + cafeId + "/board/" + cafeBoardId + "/post/" + bno;
	}

	@GetMapping("/{bno:\\d+}/modify")
	public String modify(
			@PathVariable("cafeId") Long cafeId, @PathVariable("cafeBoardId") Long cafeBoardId,
		    @PathVariable("bno") Long bno, PageRequestDTO pageRequestDTO, Model model,
			Principal principal) {

		BoardDTO boardDTO = boardService.get(bno);
		
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		if (!cafeBoardId.equals(boardDTO.getCafeBoardId())) {
	        throw new BoardNotFoundException(bno);
	    }
		
		String username = principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getWriteRole())) {
			throw new AccessDeniedException("이 게시판의 글을 수정할 권한이 없습니다.");
		}
		
		if (!username.equals(boardDTO.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 수정할 수 있습니다.");
		}
		
		model.addAttribute("canWrite", true);
		
		model.addAttribute("cafeId", cafeId);
		model.addAttribute("cafeBoard", cafeBoard);
		model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
		model.addAttribute("board", boardDTO);
		model.addAttribute("pageRequest", pageRequestDTO);
		model.addAttribute("attachList", boardAttachService.getList(bno));
		
		return "board/modify";
	}

	@PostMapping("/{bno:\\d+}/modify")
	public String modify(
			@PathVariable("cafeId") Long cafeId, @PathVariable("cafeBoardId") Long cafeBoardId,
			@PathVariable("bno") Long bno, @Valid @ModelAttribute("board") BoardDTO boardDTO,
			BindingResult bindingResult, PageRequestDTO pageRequestDTO,
			Model model, Principal principal,
			@RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
			@RequestParam(value = "deleteAnoList", required = false) List<Long> deleteAnoList) {

		// 1. DB에 원본 게시글 조회
		BoardDTO savedBoard = boardService.get(bno);
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		if (!cafeBoardId.equals(savedBoard.getCafeBoardId())) {
	        throw new BoardNotFoundException(bno);
	    }
		
		// 2. 게시판에 글을 수정할 권한 확인
		String username = principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getWriteRole())) {
			throw new AccessDeniedException("이 게시판의 글을 수정할 권한이 없습니다.");
		}

		// 3. 원래 작성자와 현재 로그인 사용자 비교
		if (!username.equals(savedBoard.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 수정할 수 있습니다.");
		}
		
		// 4. 입력값 검증
		if (bindingResult.hasErrors()) {
			model.addAttribute("errors", bindingResult.getAllErrors());
			
			model.addAttribute("canWrite", true);
			
			model.addAttribute("cafeId", cafeId);
			model.addAttribute("cafeBoard", cafeBoard);
			model.addAttribute("cafeBoardList", cafeBoardService.getList(cafeId));
			model.addAttribute("pageRequest", pageRequestDTO);
			model.addAttribute("attachList", boardAttachService.getList(bno));
			
			return "board/modify";
		}

		// 5. 작성자가 맞을 때만 수정
		boardDTO.setBno(bno);
		boardDTO.setCafeBoardId(savedBoard.getCafeBoardId());
		boardDTO.setWriter(savedBoard.getWriter());
		
		boardService.modify(boardDTO);

		if (uploadFiles != null) {
			for (MultipartFile uploadFile : uploadFiles) {
				if (uploadFile.isEmpty()) {
					continue;
				}

				boardAttachService.register(bno, uploadFile);
			}
		}

		if(deleteAnoList != null) { 
			for(Long ano : deleteAnoList) {
				boardAttachService.remove(bno, ano);
			} 
		}
		 

		return "redirect:/cafe/" + cafeId + "/board/" + cafeBoardId + "/post/"
        + bno + "?" + pageRequestDTO.getLink();
	}

	@PostMapping("/{bno:\\d+}/remove")
	public String remove(
		@PathVariable("cafeId") Long cafeId, @PathVariable("cafeBoardId") Long cafeBoardId,
		@PathVariable("bno") Long bno, Principal principal) {
		
		BoardDTO savedBoard = boardService.get(bno);
		CafeBoardDTO cafeBoard = cafeBoardService.get(cafeId, cafeBoardId);
		
		if (!cafeBoardId.equals(savedBoard.getCafeBoardId())) {
		    throw new BoardNotFoundException(bno);
		}

		String username = principal.getName();
		
		if (!cafeBoardAccessService.canAccess(cafeId, username, cafeBoard.getWriteRole())){
		    throw new AccessDeniedException("이 게시판의 글을 삭제할 권한이 없습니다.");
		}
		
		if (!username.equals(savedBoard.getWriter())) {
			throw new AccessDeniedException("본인의 게시글만 삭제할 수 있습니다.");
		}
		
		boardService.remove(bno);
		
		return "redirect:/cafe/" + cafeId + "/board/" + cafeBoardId + "/post";
	}
}
