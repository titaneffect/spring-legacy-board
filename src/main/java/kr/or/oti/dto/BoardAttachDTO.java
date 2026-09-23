package kr.or.oti.dto;

import java.time.LocalDateTime;

import kr.or.oti.domain.AttachUsage;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class BoardAttachDTO {
	
	private Long ano;
	private Long bno;
	
	private String uuid;
	private String fileName;
	private String uploadPath;
	
	private Long fileSize;
	private String contentType;
	private AttachUsage attachUsage;
	
	private LocalDateTime regDate;
}
