package kr.or.oti.dto;

import java.nio.charset.StandardCharsets;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;

import org.springframework.web.util.UriUtils;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageRequestDTO {

	@Builder.Default
	@Min(1)
	private int page = 1;
	
	@Builder.Default
	@Min(1)
	@Max(100)
	private int size = 10;
	
	@Builder.Default
	private String type = "T";
	
	private String keyword;
	
	public int getSkip() {
		return (page - 1) * size;
	}
	
	public String getLink() {
		StringBuilder builder = new StringBuilder();
		
		builder.append("page=").append(page);
		builder.append("&size=").append(size);
		builder.append("&type=")
				.append(UriUtils.encodeQueryParam(
						type == null ? "" : type, StandardCharsets.UTF_8));
		
		if(keyword != null && !keyword.isEmpty()) {
			builder.append("&keyword=")
					.append(UriUtils.encodeQueryParam(
							keyword, StandardCharsets.UTF_8));
		}
		
		return builder.toString();
	}
}
