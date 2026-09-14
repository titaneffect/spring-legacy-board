package kr.or.oti.exception;

public class ReplyNotFoundException extends RuntimeException{
	
	private static final long serialVersionUID = 1L;
	
	public ReplyNotFoundException(Long rno) {
		super("댓글을 찾을 수 없습니다. rno = " + rno);
	}
}
