package kr.or.oti.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.BoardVO;
import kr.or.oti.dto.PageRequestDTO;

public interface BoardMapper {
	
	List<BoardVO> selectPage(
			@Param("cafeBoardId")Long cafeBoardId,
			@Param("pageRequest")PageRequestDTO pageRequestDTO);
			
	int selectTotalCount(
			@Param("cafeBoardId")Long cafeBoardId,
			@Param("pageRequest")PageRequestDTO pageRequestDTO);
	
	BoardVO selectOne(Long bno);
	
	int insertOne(BoardVO boardVO);
	
	int updateOne(BoardVO boardVO);
	
	int deleteOne(Long bno);
	
}
