package kr.or.oti.domain;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MemberVO {
	
	private String username;
	
	@ToString.Exclude
	private String password;
		
	private boolean enabled;
	
	private LocalDateTime regDate;

	private List<MemberAuthVO> authList;
}
