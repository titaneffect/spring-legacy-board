package kr.or.oti.domain;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class CafeMemberVO {

	private Long cafeMemberId;
	
	private Long cafeId;
	
	private String memberUsername;
	
	private CafeRole cafeRole;
	
	private String status;
	
	private LocalDateTime joinedAt;
}
