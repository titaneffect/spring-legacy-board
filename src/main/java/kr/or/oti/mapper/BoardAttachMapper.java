package kr.or.oti.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.or.oti.domain.AttachUsage;
import kr.or.oti.domain.BoardAttachVO;

public interface BoardAttachMapper {

	List<BoardAttachVO> selectByBno(Long bno);
	
	List<BoardAttachVO> selectByBnoAndUsage(
			@Param("bno")Long bno, @Param("attachUsage")AttachUsage attachUsage);
	
	BoardAttachVO selectOne(Long ano);
	
	void insertOne(BoardAttachVO boardAttachVO);
	
	int deleteOne(Long ano);

}
