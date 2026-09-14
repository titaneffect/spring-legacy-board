package kr.or.oti.dto;

import java.time.LocalDateTime;

import javax.validation.constraints.NotBlank;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReplyDTO {
	
	private Long rno;
	
	private Long bno;
	
	@NotBlank(message = "내용을 입력하세요.")
	private String reply;
	
	@NotBlank(message = "작성자를 입력하세요.")
	private String replyer;
	
	private LocalDateTime regDate;
	
	private LocalDateTime modDate;
}
