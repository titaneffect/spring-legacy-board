package kr.or.oti.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.dto.BoardAttachDTO;

public interface BoardAttachService {
	
	List<BoardAttachDTO> getList(Long bno);
	
	BoardAttachDTO get(Long ano);
	
	void register(Long bno, MultipartFile uploadFile);
	
	void remove(Long bno, Long ano);
	
	void removeAll(Long bno);

}
