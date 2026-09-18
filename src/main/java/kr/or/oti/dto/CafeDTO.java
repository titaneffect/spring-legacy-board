package kr.or.oti.dto;

import java.time.LocalDateTime;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CafeDTO {

	private Long cafeId;
	
	@NotBlank(message = "카페 이름을 입력해주세요.")
	@Size(max = 100, message = "카페 이름은 100자 이하로 입력해주세요.")
	private String cafeName;
	
	@Size(max = 500, message = "카페 설명은 500자 이하로 입력해주세요.")
	private String description;
	
	private String ownerUsername;
	
	private String status;
	
	private LocalDateTime createdAt;
	
	private LocalDateTime updatedAt;
}
