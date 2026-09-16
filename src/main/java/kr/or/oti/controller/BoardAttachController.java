package kr.or.oti.controller;

import org.springframework.core.io.Resource;
import org.springframework.http.InvalidMediaTypeException;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.oti.dto.BoardAttachDTO;
import kr.or.oti.service.BoardAttachService;
import kr.or.oti.service.FileStorageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/attachments")
@RequiredArgsConstructor
public class BoardAttachController {

	private final BoardAttachService boardAttachService;
	private final FileStorageService fileStorageService;
	
	@GetMapping("/{ano}/view")
	public ResponseEntity<Resource> view(@PathVariable("ano")Long ano){
		//1. DB에서 첨부파일 정보 조회
		BoardAttachDTO boardAttachDTO = boardAttachService.get(ano);
		
		if(boardAttachDTO == null) {
			return ResponseEntity.notFound().build();
		}
		
		//2. 디스크에서 실제 파일 조회
		Resource resource = fileStorageService.load(boardAttachDTO);
		
		//3. 기본 응답 형식
		MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;
		
		//4. DB에 저장된 Content-Type 적용
		if(boardAttachDTO.getContentType() != null) {
			try {
				mediaType = MediaType.parseMediaType(boardAttachDTO.getContentType());
			} catch(InvalidMediaTypeException e) {
				// 잘못된 Content-Type이면 application/octet-stream 사용
			}
		}
		
		//5. 실제 파일을 HTTP 응답 본문에 담는다.
		return ResponseEntity.ok().contentType(mediaType).body(resource);
	}
}
