package kr.or.oti.domain;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardAttachVO {
	
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
