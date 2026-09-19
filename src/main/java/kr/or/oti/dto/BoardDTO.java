package kr.or.oti.dto;

import java.time.LocalDateTime;

import javax.validation.constraints.NotBlank;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BoardDTO {

    private Long bno;
    
    private Long cafeBoardId;
    
    @NotBlank(message = "제목을 입력하세요.")
    private String title;
    
    @NotBlank(message = "내용을 입력하세요.")
    private String content;
    
    @NotBlank(message = "작성자를 입력하세요.")
    private String writer;
    
    private LocalDateTime regDate;
    
    private LocalDateTime modDate;
}
