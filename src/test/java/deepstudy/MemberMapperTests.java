package deepstudy;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class MemberMapperTests {
	
	@Test
	void passwordEncodeTest() {
	    BCryptPasswordEncoder encoder =
	            new BCryptPasswordEncoder();

	    String encodedPassword =
	            encoder.encode("test-password");

	    System.out.println(encodedPassword);
	}
}
