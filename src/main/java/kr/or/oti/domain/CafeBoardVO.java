package kr.or.oti.domain;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class CafeBoardVO {

	private Long cafeBoardId;
	
	private Long cafeId;
	
	private String boardName;
	
	private CafeBoardType boardType;
	
	private CafeBoardAccessLevel readRole;
	
	private CafeBoardAccessLevel writeRole;
	
	private Integer displayOrder;
	
	private CafeBoardStatus status;

	private LocalDateTime createdAt;
	
	private LocalDateTime updatedAt;
}
