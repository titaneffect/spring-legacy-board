package kr.or.oti.mapper;

import java.util.List;

import kr.or.oti.domain.BoardAttachVO;

public interface BoardAttachMapper {

	List<BoardAttachVO> selectByBno(Long bno);
	
	BoardAttachVO selectOne(Long ano);
	
	void insertOne(BoardAttachVO boardAttachVO);
}
