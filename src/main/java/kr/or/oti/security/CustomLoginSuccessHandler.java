package kr.or.oti.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	private final RequestCache requestCache = new HttpSessionRequestCache();
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		HttpSession session = request.getSession(false);
		
		Long returnCafeId = null;
		Long returnCafeBoardId = null;
        Long returnBno = null;
		
		if(session != null) {
			returnCafeId = (Long)session.getAttribute("loginReturnCafeId");
			returnCafeBoardId = (Long) session.getAttribute("loginReturnCafeBoardId");
			returnBno = (Long) session.getAttribute("loginReturnBno");
			
			session.removeAttribute("loginReturnCafeId");
			session.removeAttribute("loginReturnCafeBoardId");
            session.removeAttribute("loginReturnBno");
		}
		
		/*
	     * 로그인 전에 Spring Security가 차단한 URL이 있으면
	     * 해당 URL을 가장 우선해서 사용
	     */
		
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if (savedRequest != null) {
	        response.sendRedirect(savedRequest.getRedirectUrl());
	        return;
	    }
		
		/*
	     * 게시글 화면에서 직접 로그인 버튼을 누른 경우
	     */
		
		if(returnCafeId != null && returnCafeBoardId != null) {
			String redirectUrl = request.getContextPath() + "/cafe/" + returnCafeId + "/board/" + returnCafeBoardId + "/post";
			
			if(returnBno != null) {
				// 게시글에서 댓글 작성을 위해 로그인한 경우
		        redirectUrl += "/" + returnBno;
			} else {
				// 사이드바의 로그인하고 글쓰기를 누른 경우
				redirectUrl += "/register";
			}
			
			response.sendRedirect(response.encodeRedirectURL(redirectUrl));
			return;
		}
		
		 /*
	     * 이전 접근 주소도 없고 별도 복귀 주소도 없는 일반 로그인
	     */
		
		response.sendRedirect(request.getContextPath() + "/cafe");
		
	}
}
