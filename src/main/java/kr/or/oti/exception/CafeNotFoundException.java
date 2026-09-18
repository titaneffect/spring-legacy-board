package kr.or.oti.exception;

public class CafeNotFoundException extends RuntimeException{

	private static final long serialVersionUID = 1L;
	
	public CafeNotFoundException(Long cafeId) {
		super("카페를 찾을 수 없습니다. cafeId = " + cafeId);
	}
}
