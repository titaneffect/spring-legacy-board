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
        String returnUrl = null;
		
		if(session != null) {
			returnCafeId = (Long)session.getAttribute("loginReturnCafeId");
			returnCafeBoardId = (Long) session.getAttribute("loginReturnCafeBoardId");
			returnBno = (Long) session.getAttribute("loginReturnBno");
			returnUrl = (String) session.getAttribute("loginReturnUrl");
			
			/*
             * 로그인 성공 후에는 복귀 정보를 모두 제거한다.
             * 다음 로그인에서 같은 주소가 재사용되는 것을 막는다.
             */
			
			session.removeAttribute("loginReturnCafeId");
			session.removeAttribute("loginReturnCafeBoardId");
            session.removeAttribute("loginReturnBno");
            session.removeAttribute("loginReturnUrl");
		}
		
		/*
         * 1. Spring Security가 보호된 URL을 차단한 경우
         *
         * 예:
         * 비로그인 상태에서 글쓰기 URL에 직접 접근
         */
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		
		if (savedRequest != null) {
	        response.sendRedirect(savedRequest.getRedirectUrl());
	        return;
	    }
		
		/*
         * 2. 공통 헤더에서 로그인한 경우
         *
         * 사용자가 로그인 버튼을 누르기 전에 보고 있던 공개 페이지로 이동한다.
         */
		if (returnUrl != null) {
		    response.sendRedirect(response.encodeRedirectURL(returnUrl));
		    return;
		}
		
		/*
         * 3. 댓글 작성 또는 로그인 후 글쓰기인 경우
         */
		if(returnCafeId != null && returnCafeBoardId != null) {
			String redirectUrl = request.getContextPath() + "/cafe/" + returnCafeId + "/board/" + returnCafeBoardId + "/post";
			
			if(returnBno != null) {
				// 게시글에서 상세 화면에서 게시글 작성을 위해 로그인한 경우
		        redirectUrl += "/" + returnBno;
			} else {
				// 사이드바에서 로그인하고 글쓰기를 누른 경우
				redirectUrl += "/register";
			}
			
			response.sendRedirect(response.encodeRedirectURL(redirectUrl));
			return;
		}
		
		/*
         * 4. 복귀 주소 없이 로그인 페이지에
         * 직접 접근한 경우
         */
		response.sendRedirect(request.getContextPath() + "/cafe");
		
	}
}
