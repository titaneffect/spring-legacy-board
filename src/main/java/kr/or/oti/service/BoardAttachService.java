package kr.or.oti.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.domain.AttachUsage;
import kr.or.oti.dto.BoardAttachDTO;

public interface BoardAttachService {
	
	List<BoardAttachDTO> getList(Long bno);
	
	BoardAttachDTO get(Long ano);
	
	Long register(Long bno, MultipartFile uploadFile, AttachUsage attachUsage);
	
	void remove(Long bno, Long ano);
	
	void removeAll(Long bno);
	
	String registerContentImages(
	        Long bno,
	        String content,
	        List<MultipartFile> contentImages,
	        List<String> contentImageTokens
	);
	
	void removeUnusedContentImages(Long bno, String content);

}
