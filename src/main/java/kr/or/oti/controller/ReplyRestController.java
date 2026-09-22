package kr.or.oti.controller;

import java.security.Principal;
import java.util.List;

import javax.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.oti.domain.CafeRole;
import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.CafeBoardDTO;
import kr.or.oti.dto.ReplyDTO;
import kr.or.oti.service.BoardService;
import kr.or.oti.service.CafeBoardAccessService;
import kr.or.oti.service.CafeBoardService;
import kr.or.oti.service.ReplyService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/replies")
@RequiredArgsConstructor
public class ReplyRestController {

	private final BoardService boardService;
	private final ReplyService replyService;
	private final CafeBoardService cafeBoardService;
	private final CafeBoardAccessService cafeBoardAccessService;
	
	@GetMapping
	public List<ReplyDTO> getList(@RequestParam("bno")Long bno,
			Principal principal){
		
		BoardDTO board = boardService.get(bno);
		
		CafeBoardDTO cafeBoard = cafeBoardService.getById(board.getCafeBoardId());
		
		String username = principal == null ? null : principal.getName();
		
		if(!cafeBoardAccessService.canAccess(cafeBoard.getCafeId(),
				username, cafeBoard.getReadRole())) {
			
			throw new AccessDeniedException("이 게시판의 댓글을 조회할 권한이 없습니다.");
		}
		
		return replyService.getList(bno);
	}
	
	@PostMapping
	public ResponseEntity<String> register(
		@Valid @RequestBody ReplyDTO replyDTO, Principal principal){
		
		// 요청의 bno로 실제 게시글과 소속 게시판을 조회
		BoardDTO board = boardService.get(replyDTO.getBno());
		
		CafeBoardDTO cafeBoard = cafeBoardService.getById(board.getCafeBoardId());
		
		// 로그인만 했는지가 아니라 카페 게시판 쓰기 권한도 확인
		if(!cafeBoardAccessService.canAccess(cafeBoard.getCafeId(),
				principal.getName(), cafeBoard.getWriteRole())){
			
			throw new AccessDeniedException("이 게시판에 댓글을 작성할 권한이 없습니다.");
		}
		
		// 댓글 작성자는 요청값이 아닌 로그인 사용자로 결정
		replyDTO.setReplyer(principal.getName());
		replyService.register(replyDTO);
		
		return ResponseEntity
				.status(HttpStatus.CREATED)
				.body("success");
	}
	
	@PutMapping("/{rno}")
	public ResponseEntity<Void> modify(
		@PathVariable("rno")Long rno, 
		@Valid @RequestBody ReplyDTO replyDTO, Principal principal){
		
		//1. 해당 댓글이 실제로 존재하는지 확인
		//2. 실제 작성자가 현재 로그인 사용자인지 확인
		// 요청 데이터는 클라이언트가 조작할 수 있으므로,
		// URL의 rno로 DB 원본을 조회해 실제 작성자를 확인한다.
		ReplyDTO savedReply = replyService.get(rno);
		
		BoardDTO board = boardService.get(savedReply.getBno());
		
		CafeBoardDTO cafeBoard =
				cafeBoardService.getById(board.getCafeBoardId());
		
		if(!cafeBoardAccessService.canAccess(cafeBoard.getCafeId(),
				principal.getName(), cafeBoard.getWriteRole())) {
			
			throw new AccessDeniedException("이 게시판의 댓글을 수정할 권한이 없습니다.");
		}
		
		if(!principal.getName().equals(savedReply.getReplyer())) {
			throw new AccessDeniedException(
				"본인의 댓글만 수정할 수 있습니다."
			);
		}
		
		// 클라이언트가 수정할 수 있는 댓글 내용만 원본에 반영한다.
		// rno, bno, replyer 등은 DB에 저장된 원본 값을 유지한다.
		savedReply.setReply(replyDTO.getReply());
		
		replyService.modify(savedReply);
		
		return ResponseEntity
				.noContent()
				.build();
	}
	
	@DeleteMapping("/{rno}")
	public ResponseEntity<Void> remove(
		@PathVariable("rno") Long rno, Principal principal){
		
		ReplyDTO savedReply = replyService.get(rno);
		
		BoardDTO board = boardService.get(savedReply.getBno());
		
		CafeBoardDTO cafeBoard =
				cafeBoardService.getById(board.getCafeBoardId());
		
		if(!cafeBoardAccessService.canAccess(cafeBoard.getCafeId(),
				principal.getName(), cafeBoard.getWriteRole())) {
			
			throw new AccessDeniedException("이 게시판의 댓글을 삭제할 권한이 없습니다.");
		}
		
		if(!principal.getName().equals(savedReply.getReplyer())) {
			throw new AccessDeniedException(
				"본인의 댓글만 삭제할 수 있습니다."
			);
		}
		
		replyService.remove(rno);
		
		return ResponseEntity
				.noContent()
				.build();
	}
}
