package kr.or.oti.service;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.oti.domain.BoardAttachVO;
import kr.or.oti.dto.BoardAttachDTO;

@Service
public class FileStorageService {
	
	@Value("${upload.root}")
	private String uploadRoot;
	
	public Resource load(BoardAttachDTO boardAttachDTO) {
		
		Path rootPath = Paths.get(uploadRoot)
							.toAbsolutePath()
							.normalize();
		
		String storedFileName = boardAttachDTO.getUuid()
									+ "_" + boardAttachDTO.getFileName();
		
		Path filePath = rootPath
							.resolve(boardAttachDTO.getUploadPath())
							.resolve(storedFileName)
							.normalize();
		
		// 지정된 업로드 폴더 밖으로 벗어나는 경로 방지
		if(!filePath.startsWith(rootPath)) {
			throw new IllegalStateException("잘못된 파일 경로입니다.");
		}
		
		try {
			Resource resource = new UrlResource(filePath.toUri());
			
			if(!resource.exists() || !resource.isReadable()) {
				throw new IllegalStateException("파일을 찾을 수 없습니다.");
			}
			
			return resource;
		} catch(MalformedURLException e){
			throw new IllegalStateException("파일 경로를 불러올 수 없습니다.", e);
		}
	}
	
	public BoardAttachVO store(MultipartFile uploadFile) {		
		//1. 비어 있는 파일 검사	
		if(uploadFile == null || uploadFile.isEmpty()) {
			throw new IllegalArgumentException("저장할 파일이 없습니다.");
		}
		
		String originalFileName = uploadFile.getOriginalFilename();
		
		//2. 사용자가 업로드한 파일명
		if(originalFileName == null || originalFileName.trim().isEmpty()) {
			throw new IllegalArgumentException("파일명이 없습니다.");
		}
		
		//3. 파일명에 포함될 수 있는 경로 제거
		originalFileName = Paths
							.get(originalFileName)
							.getFileName()
							.toString();
		
		//4. 물리적 파일명 충돌 방지를 위한 UUID
		String uuid = UUID.randomUUID().toString();
		
		String storedFileName = uuid + "_" + originalFileName;
		
		//5. 날짜별 상대 저장 경로
		String uploadPath = LocalDate.now().format(
				DateTimeFormatter.ofPattern("yyyy/MM/dd"));
							
		//6. 실제 저장 폴더 경로
		Path uploadDirectory = Paths
								.get(uploadRoot)
								.resolve(uploadPath);
		
		//7. 최종 파일 경로
		Path targetPath = uploadDirectory
							.resolve(storedFileName);
		
		try {
			//해당 날짜의 폴더가 없으면 생성
			Files.createDirectories(uploadDirectory);
			
			//실제 파일 저장
			uploadFile.transferTo(targetPath.toFile());
		} catch(IOException e) {
			throw new IllegalStateException("파일 저장에 실패했습니다: " + originalFileName, e);
		}
		
		//8. DB에 저장할 첨부파일 정보 반환
		return BoardAttachVO.builder()
							.uuid(uuid)
							.fileName(originalFileName)
							.uploadPath(uploadPath)
							.fileSize(uploadFile.getSize())
							.contentType(uploadFile.getContentType())
							.build();
	}
	
	public void delete(BoardAttachDTO boardAttachDTO) {
		Path rootPath = Paths.get(uploadRoot)
							.toAbsolutePath()
							.normalize();
		
		String storedFileName = boardAttachDTO.getUuid()
				+ "_" + boardAttachDTO.getFileName();
		
		Path filePath = rootPath
							.resolve(boardAttachDTO.getUploadPath())
							.resolve(storedFileName)
							.normalize();
		
		if(!filePath.startsWith(rootPath)) {
			throw new IllegalStateException("잘못된 파일 경로입니다.");
		}
		
		try {
			Files.deleteIfExists(filePath);
		} catch(IOException e) {
			throw new IllegalStateException("파일 삭제에 실패했습니다: "
						+ boardAttachDTO.getFileName(), e);
		}
									
	}
}
