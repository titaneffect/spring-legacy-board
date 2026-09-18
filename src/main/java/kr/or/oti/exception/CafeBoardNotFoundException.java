package kr.or.oti.exception;

public class CafeBoardNotFoundException extends RuntimeException {
	
	private static final long serialVersionUID = 1L;

	public CafeBoardNotFoundException(Long cafeId, Long cafeBoardId) {
		super("카페 게시판을 찾을 수 없습니다. cafeId=" + cafeId + ", cafeBoardId=" + cafeBoardId);
	}
}
