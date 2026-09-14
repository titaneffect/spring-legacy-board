package kr.or.oti.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		HttpSession session = request.getSession(false);
		Long returnBno = null;
		
		if(session != null) {
			returnBno = (Long)session.getAttribute("loginReturnBno");
			session.removeAttribute("loginReturnBno");
		}
		
		if(returnBno != null) {
			response.sendRedirect(request.getContextPath() + "/board/read?bno=" + returnBno);
			return;
		}
		
		response.sendRedirect(request.getContextPath() + "/board/list");
		
	}
}
