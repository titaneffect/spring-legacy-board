package kr.or.oti.mapper;

import java.util.List;

import kr.or.oti.domain.BoardVO;
import kr.or.oti.dto.PageRequestDTO;

public interface BoardMapper {
	
	List<BoardVO> selectPage(PageRequestDTO pageRequestDTO);
	int selectTotalCount(PageRequestDTO pageRequestDTO);
	BoardVO selectOne(Long bno);
	int insertOne(BoardVO boardVO);
	int updateOne(BoardVO boardVO);
	int deleteOne(Long bno);
	
}
