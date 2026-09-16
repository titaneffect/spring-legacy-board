package kr.or.oti.controller.advice;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import kr.or.oti.controller.ReplyRestController;
import kr.or.oti.dto.ApiErrorDTO;
import kr.or.oti.exception.ReplyNotFoundException;

@RestControllerAdvice(assignableTypes = ReplyRestController.class)
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RestExceptionHandler {
	
	@ExceptionHandler(MethodArgumentNotValidException.class)
	public ResponseEntity<ApiErrorDTO> handleValidation(
			MethodArgumentNotValidException exception){
		
		Map<String, String> errors = new LinkedHashMap<>();
		
		for(FieldError fieldError : exception.getBindingResult()
											.getFieldErrors()) {
			
			errors.putIfAbsent(
				fieldError.getField(),
				fieldError.getDefaultMessage()
			);
		}
		
		ApiErrorDTO body = ApiErrorDTO.builder()
				.status(400)
				.message("입력값 검증에 실패했습니다.")
				.errors(errors)
				.build();
		
		return ResponseEntity
				.status(HttpStatus.BAD_REQUEST)
				.body(body);
	}
	
	@ExceptionHandler(ReplyNotFoundException.class)
	public ResponseEntity<ApiErrorDTO> handleNotFound(
			ReplyNotFoundException exception){
		
		ApiErrorDTO body = ApiErrorDTO.builder()
				.status(404)
				.message(exception.getMessage())
				.errors(Collections.emptyMap())
				.build();
		
		return ResponseEntity
				.status(HttpStatus.NOT_FOUND)
				.body(body);
	}
	
	@ExceptionHandler(AccessDeniedException.class)
	public ResponseEntity<ApiErrorDTO> handleAccessDenied(
			AccessDeniedException exception){
		
		ApiErrorDTO body = ApiErrorDTO.builder()
				.status(403)
				.message(exception.getMessage())
				.errors(Collections.emptyMap())
				.build();
		
		return ResponseEntity
				.status(HttpStatus.FORBIDDEN)
				.body(body);
	}
}
