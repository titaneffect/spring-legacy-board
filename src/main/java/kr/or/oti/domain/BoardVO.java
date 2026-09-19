package kr.or.oti.domain;

import java.time.LocalDateTime;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class BoardVO {
	
	private Long bno;
	
	private Long cafeBoardId;
	
	private String title;
	
	private String content;
	
	private String writer;
	
	private LocalDateTime regDate;
	
	private LocalDateTime modDate;
}
