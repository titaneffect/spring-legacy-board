package kr.or.oti.mapper;

import java.util.List;

import kr.or.oti.domain.ReplyVO;

public interface ReplyMapper {
	List<ReplyVO> selectAll(Long bno);
	ReplyVO selectOne(Long rno);
	int insertOne(ReplyVO replyVO);
	int updateOne(ReplyVO replyVO);
	int deleteOne(Long rno);
	void deleteAllByBno(Long bno);
}
