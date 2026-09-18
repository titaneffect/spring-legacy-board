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
public class CafeVO {
	
	private Long cafeId;
	
	private String cafeName;
	
	private String description;
	
	private String ownerUsername;
	
	private String status;
	
	private LocalDateTime createdAt;
	
	private LocalDateTime updatedAt;
}
