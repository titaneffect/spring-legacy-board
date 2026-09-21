package kr.or.oti.dto;

import java.time.LocalDateTime;

import kr.or.oti.domain.CafeMemberStatus;
import kr.or.oti.domain.CafeRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CafeMemberDTO {

	private Long cafeMemberId;
	
	private Long cafeId;
	
	private String memberUsername;
	
	private CafeRole cafeRole;
	
	private CafeMemberStatus status;
	
	private LocalDateTime joinedAt;
}
