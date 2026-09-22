package kr.or.oti.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

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
public class MemberDTO {

	@NotBlank(message = "아이디를 입력하세요.")
	@Pattern(
				regexp = "^[A-Za-z0-9]{1,50}$",
				message = "아이디는 영문, 숫자만 사용할 수 있습니다."
			)
	private String username;
	
	@NotBlank(message = "비밀번호를 입력하세요.")
	private String password;
	
	@NotBlank(message = "비밀번호 확인을 입력하세요.")
	private String passwordConfirm;
}
