package kr.or.oti.dto;

import java.util.Map;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ApiErrorDTO {
	
	private int status;
	
	private String message;
	
	private Map<String, String> errors;
}
