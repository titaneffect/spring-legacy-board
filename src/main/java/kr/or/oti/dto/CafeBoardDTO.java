package kr.or.oti.dto;

import java.time.LocalDateTime;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import kr.or.oti.domain.CafeBoardAccessLevel;
import kr.or.oti.domain.CafeBoardStatus;
import kr.or.oti.domain.CafeBoardType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CafeBoardDTO {

	private Long cafeBoardId;

	private Long cafeId;
	
	@NotBlank(message = "게시판 이름을 입력해주세요.")
	@Size(max = 50, message = "게시판 이름은 50자 이하로 입력해주세요.")
	private String boardName;
	
	@NotNull(message = "게시판 유형을 선택해주세요.")
	private CafeBoardType boardType;
	
	@NotNull(message = "읽기 권한을 선택해주세요.")
	private CafeBoardAccessLevel readRole;
	
	@NotNull(message = "쓰기 권한을 선택해주세요.")
	private CafeBoardAccessLevel writeRole;
	
	@Builder.Default
	@NotNull(message = "표시 순서를 입력해주세요.")
	@Min(value = 0, message = "표기 순서는 0 이상이어야 합니다.")
	private Integer displayOrder = 0;
	
	private CafeBoardStatus status;
	
	private LocalDateTime createdAt;
	
	private LocalDateTime updatedAt;
}
