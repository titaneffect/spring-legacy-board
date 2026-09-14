package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import kr.or.oti.domain.ReplyVO;
import kr.or.oti.dto.ReplyDTO;
import kr.or.oti.exception.ReplyNotFoundException;
import kr.or.oti.mapper.ReplyMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService{
	private final ReplyMapper replyMapper;
	
	@Override
	public List<ReplyDTO> getList(Long bno){
		List<ReplyDTO> dtoList = replyMapper.selectAll(bno)
				.stream()
				.map(this::VOtoDTO)
				.collect(Collectors.toList());
		return dtoList;
	}
	
	@Override
	public ReplyDTO get(Long rno) {
		ReplyVO replyVO = replyMapper.selectOne(rno);
		
		if(replyVO == null) {
			throw new ReplyNotFoundException(rno);
		}
		
		return VOtoDTO(replyVO);
	}
	
	@Override
	public void register(ReplyDTO replyDTO) {
		ReplyVO replyVO = DTOtoVO(replyDTO);
		int result = replyMapper.insertOne(replyVO);
		
		if(result == 0) {
			throw new ReplyNotFoundException(replyDTO.getRno());
		}
	}
	
	@Override
	public void modify(ReplyDTO replyDTO) {
		ReplyVO replyVO = DTOtoVO(replyDTO);
		int result = replyMapper.updateOne(replyVO);
		
		if(result == 0) {
			throw new ReplyNotFoundException(replyDTO.getRno());
		}
	}
	
	@Override
	public void remove(Long rno) {
		int result = replyMapper.deleteOne(rno);
		
		if(result == 0) {
			throw new ReplyNotFoundException(rno);
		}
	}
	
	public ReplyDTO VOtoDTO(ReplyVO replyVO) {
		return ReplyDTO.builder()
				.rno(replyVO.getRno())
				.bno(replyVO.getBno())
				.reply(replyVO.getReply())
				.replyer(replyVO.getReplyer())
				.regDate(replyVO.getRegDate())
				.modDate(replyVO.getModDate())
				.build();
	}
	
	public ReplyVO DTOtoVO(ReplyDTO replyDTO) {
		return ReplyVO.builder()
				.rno(replyDTO.getRno())
				.bno(replyDTO.getBno())
				.reply(replyDTO.getReply())
				.replyer(replyDTO.getReplyer())
				.regDate(replyDTO.getRegDate())
				.modDate(replyDTO.getModDate())
				.build();
	}
}
