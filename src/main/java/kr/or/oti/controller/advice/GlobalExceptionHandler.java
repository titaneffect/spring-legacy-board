package kr.or.oti.controller.advice;

import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import kr.or.oti.exception.BoardNotFoundException;
import kr.or.oti.exception.ReplyNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
	
	@ExceptionHandler(BoardNotFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public String handleBoardNotFound(BoardNotFoundException exception, Model model) {
		model.addAttribute("message", exception.getMessage());
		model.addAttribute("exceptionName", "404 NOT FOUND");
		return "error/exception";
	}
	
	@ExceptionHandler(ReplyNotFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public String handleReplyNotFound(ReplyNotFoundException exception, Model model) {
		model.addAttribute("message", exception.getMessage());
		model.addAttribute("exceptionName", "404 NOT FOUND");
		return "error/exception";
	}
	
	@ExceptionHandler(AccessDeniedException.class)
	@ResponseStatus(HttpStatus.FORBIDDEN)
	public String handleAccessDenied(AccessDeniedException exception, Model model) {
		model.addAttribute("message", exception.getMessage());
		model.addAttribute("exceptionName", "403 FORBIDDEN");
		return "error/exception";
	}
	
}
