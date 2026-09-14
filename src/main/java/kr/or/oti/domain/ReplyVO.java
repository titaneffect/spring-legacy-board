package kr.or.oti.domain;

import java.time.LocalDateTime;

import javax.validation.constraints.NotBlank;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class ReplyVO {
	
	private Long rno;
	
	private Long bno;
	
	@NotBlank
	private String reply;
	
	@NotBlank
	private String replyer;
	
	private LocalDateTime regDate;
	
	private LocalDateTime modDate;
}