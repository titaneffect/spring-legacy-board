package kr.or.oti.domain;

public enum CafeBoardAccessLevel {
	
	GUEST(0),
	MEMBER(1),
	MANAGER(2),
	OWNER(3);
	
	private final int level;
	
	CafeBoardAccessLevel(int level){
		this.level = level;
	}
	
	public boolean isLowerThan(CafeBoardAccessLevel other) {
		return this.level < other.level;
	}

}
