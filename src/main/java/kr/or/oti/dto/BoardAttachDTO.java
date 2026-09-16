package kr.or.oti.dto;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class BoardAttachDTO {
	
	private Long ano;
	private Long bno;
	
	private String fileName;
	
	private Long fileSize;
	private String contentType;
	
	private LocalDateTime regDate;
}
