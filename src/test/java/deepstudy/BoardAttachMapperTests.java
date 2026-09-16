package deepstudy;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import kr.or.oti.domain.BoardAttachVO;
import kr.or.oti.mapper.BoardAttachMapper;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
"file:src/main/webapp/WEB-INF/spring/root-context.xml",
"file:src/main/webapp/WEB-INF/spring/security-context.xml"
})
public class BoardAttachMapperTests {
	
	@Autowired
	private BoardAttachMapper boardAttachMapper;

	@Test
	void selectByBnoTest() {
		boardAttachMapper.selectByBno(161L);
		
	}
	
	@Test
	void selelctOneTest() {
		boardAttachMapper.selectOne(1L);
	}
	
	@Test
	void insertOneTest() {
		BoardAttachVO attach = BoardAttachVO.builder()
				.bno(161L)
				.uuid("uuid")
				.fileName("fileName")
				.uploadPath("uploadPath")
				.fileSize(100L)
				.contentType("contentType")
				.build();
		boardAttachMapper.insertOne(attach);
	}
}
