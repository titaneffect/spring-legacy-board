package kr.or.oti.exception;

public class BoardNotFoundException extends RuntimeException{
	
	private static final long serialVersionUID = 1L;
	
	public BoardNotFoundException(Long bno) {
		super("게시글을 찾을 수 없습니다. bno = " + bno);
	}
}
