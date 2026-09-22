package kr.or.oti.controller;

import java.security.Principal;

import org.springframework.core.io.Resource;
import org.springframework.http.InvalidMediaTypeException;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.oti.dto.BoardAttachDTO;
import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.CafeBoardDTO;
import kr.or.oti.service.BoardAttachService;
import kr.or.oti.service.BoardService;
import kr.or.oti.service.CafeBoardAccessService;
import kr.or.oti.service.CafeBoardService;
import kr.or.oti.service.FileStorageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/attachments")
@RequiredArgsConstructor
public class BoardAttachController {

	private final BoardService boardService;
	private final CafeBoardService cafeBoardService;
	private final CafeBoardAccessService cafeBoardAccessService;
	private final BoardAttachService boardAttachService;
	private final FileStorageService fileStorageService;
	
	@GetMapping("/{ano}/view")
	public ResponseEntity<Resource> view(@PathVariable("ano")Long ano,
			Principal principal){
		
		//1. DB에서 첨부파일 정보 조회
		BoardAttachDTO attach = boardAttachService.get(ano);
		
		if(attach == null) {
			return ResponseEntity.notFound().build();
		}
		
		BoardDTO board = boardService.get(attach.getBno());
		
		CafeBoardDTO cafeBoard =
				cafeBoardService.getById(board.getCafeBoardId());
		
		String username = principal == null ? null : principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeBoard.getCafeId(),
				username, cafeBoard.getReadRole())) {
			
			throw new AccessDeniedException("이 첨부파일을 조회할 권한이 없습니다.");
		}
		
		//2. 디스크에서 실제 파일 조회
		Resource resource = fileStorageService.load(attach);
		
		//3. 기본 응답 형식
		MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;
		
		//4. DB에 저장된 Content-Type 적용
		if(attach.getContentType() != null) {
			try {
				mediaType = MediaType.parseMediaType(attach.getContentType());
			} catch(InvalidMediaTypeException e) {
				// 잘못된 Content-Type이면 application/octet-stream 사용
			}
		}
		
		//5. 실제 파일을 HTTP 응답 본문에 담는다.
		return ResponseEntity.ok().contentType(mediaType).body(resource);
	}
}
