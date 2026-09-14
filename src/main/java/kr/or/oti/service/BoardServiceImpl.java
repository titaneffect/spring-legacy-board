package kr.or.oti.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.oti.domain.BoardVO;
import kr.or.oti.dto.BoardDTO;
import kr.or.oti.dto.PageRequestDTO;
import kr.or.oti.dto.PageResponseDTO;
import kr.or.oti.exception.BoardNotFoundException;
import kr.or.oti.mapper.BoardMapper;
import kr.or.oti.mapper.ReplyMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

	private final BoardMapper boardMapper;
	private final ReplyMapper replyMapper;
	
	@Override
	public PageResponseDTO<BoardDTO> getList(PageRequestDTO pageRequestDTO){
		List<BoardDTO> dtoList = boardMapper.selectPage(pageRequestDTO)
			.stream()
			.map(this::VOtoDTO)
			.collect(Collectors.toList());
		
		int total = boardMapper.selectTotalCount(pageRequestDTO);
		
		return new PageResponseDTO<>(pageRequestDTO, dtoList, total);
	}

	@Override
	public BoardDTO get(Long bno) {
		BoardVO boardVO = boardMapper.selectOne(bno);
		
		if(boardVO == null) {
			throw new BoardNotFoundException(bno);
		}
		
		return VOtoDTO(boardVO);
	}
	
	@Override
	public void register(BoardDTO boardDTO) {
		BoardVO boardVO = DTOtoVO(boardDTO);
		int result = boardMapper.insertOne(boardVO);
		
		if(result == 0) {
			throw new BoardNotFoundException(boardDTO.getBno());
		}
	}
	
	@Override
	public void modify(BoardDTO boardDTO) {
		BoardVO boardVO = DTOtoVO(boardDTO);
		int result = boardMapper.updateOne(boardVO);
		
		if(result == 0) {
			throw new BoardNotFoundException(boardDTO.getBno());
		}
	}
	
	@Override
	@Transactional
	public void remove(Long bno) {
		replyMapper.deleteAllByBno(bno);
		
		int result = boardMapper.deleteOne(bno);
		
		if(result == 0) {
			throw new BoardNotFoundException(bno);
		}
	}
	
	private BoardDTO VOtoDTO(BoardVO boardVO) {
		return BoardDTO.builder()
				.bno(boardVO.getBno())
				.title(boardVO.getTitle())
				.content(boardVO.getContent())
				.writer(boardVO.getWriter())
				.regDate(boardVO.getRegDate())
				.modDate(boardVO.getModDate())
				.build();
	}
	
	private BoardVO DTOtoVO(BoardDTO boardDTO) {
		return BoardVO.builder()
				.bno(boardDTO.getBno())
				.title(boardDTO.getTitle())
				.content(boardDTO.getContent())
				.writer(boardDTO.getWriter())
				.build();
	}
}
