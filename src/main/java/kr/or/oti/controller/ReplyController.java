package kr.or.oti.controller;

import java.security.Principal;

import javax.validation.Valid;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.oti.dto.PageRequestDTO;
import kr.or.oti.dto.ReplyDTO;
import kr.or.oti.service.ReplyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/reply")
@RequiredArgsConstructor
@Slf4j
public class ReplyController {
	
	private final ReplyService replyService;
	
	@PostMapping("/register")
	public String register(@Valid ReplyDTO replyDTO, BindingResult bindingResult,
			PageRequestDTO pageRequestDTO, RedirectAttributes redirectAttributes,
			Principal principal) {
		
		if(bindingResult.hasErrors()) {
			log.info("has errors....");
			redirectAttributes.addFlashAttribute("registerErrors", bindingResult.getAllErrors());
			redirectAttributes.addFlashAttribute("replyInputRegister", replyDTO);
			return "redirect:/board/read?bno=" + replyDTO.getBno() 
			+ "&" + pageRequestDTO.getLink();
		}
		
		replyDTO.setReplyer(principal.getName());
		
		replyService.register(replyDTO);
		return "redirect:/board/read?bno=" + replyDTO.getBno() 
			+ "&" + pageRequestDTO.getLink();
	}
	
	@PostMapping("/modify")
	public String modify(@Valid ReplyDTO replyDTO, BindingResult bindingResult,
			PageRequestDTO pageRequestDTO, RedirectAttributes redirectAttributes,
			Principal principal) {
		ReplyDTO savedReply = replyService.get(replyDTO.getRno());
		Long savedBno = savedReply.getBno();
		
		if(!principal.getName().equals(savedReply.getReplyer())) {
			throw new AccessDeniedException("본인의 댓글만 수정할 수 있습니다.");
		}
		
		if(bindingResult.hasErrors()) {
			log.info("has errors....");
			redirectAttributes.addFlashAttribute("modifyErrors", bindingResult.getAllErrors());
			redirectAttributes.addFlashAttribute("replyInputModify", replyDTO);
			return "redirect:/board/read?bno=" + savedBno
			+ "&" + pageRequestDTO.getLink();
		}
		
		replyService.modify(replyDTO);
		return "redirect:/board/read?bno=" + savedBno
			+ "&" + pageRequestDTO.getLink();
	}
	
	@PostMapping("/remove")
	public String remove(Long rno, PageRequestDTO pageRequestDTO,
			Principal principal) {
		ReplyDTO savedReply = replyService.get(rno);
		
		if(!principal.getName().equals(savedReply.getReplyer())) {
			throw new AccessDeniedException("본인의 댓글만 삭제할 수 있습니다.");
		}
		
		replyService.remove(rno);
		return "redirect:/board/read?bno=" + savedReply.getBno()
		+ "&" + pageRequestDTO.getLink();
	}

}
