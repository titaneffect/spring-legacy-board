package kr.or.oti.service;

import java.util.List;

import kr.or.oti.dto.ReplyDTO;

public interface ReplyService {
	List<ReplyDTO> getList(Long bno);
	ReplyDTO get(Long rno);
	void register(ReplyDTO replyDTO);
	void modify(ReplyDTO replyDTO);
	void remove(Long rno);
}
