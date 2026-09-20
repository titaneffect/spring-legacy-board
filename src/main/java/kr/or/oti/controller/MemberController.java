package kr.or.oti.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.oti.dto.MemberDTO;
import kr.or.oti.exception.DuplicateUsernameException;
import kr.or.oti.exception.PasswordMismatchException;
import kr.or.oti.service.MemberService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {
	
	private final MemberService memberService;
	

    //Spring Security가 로그인 전에 저장한 요청을 조회하거나 제거할 때 사용한다.
    private final RequestCache requestCache = new HttpSessionRequestCache();

	@GetMapping("/login")
	public String login(
			@RequestParam(value = "returnUrl", required = false) String returnUrl,	
			@RequestParam(value = "cafeId", required = false) Long cafeId,
			@RequestParam(value = "cafeBoardId", required = false) Long cafeBoardId,
			@RequestParam(value = "bno", required = false) Long bno,
			HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model) {
		
		String contextPath = request.getContextPath();
		
		//돌아갈 주소가 없는 경우 사용하는 기본 주소
		String loginBackUrl = contextPath + "/cafe";
		
		/*
         * 1. 공통 헤더의 로그인 버튼으로 들어온 경우
         * 사용자가 보고 있던 공개 페이지가 returnUrl로 전달된다.
         */
		if (isSafeReturnUrl(returnUrl, request.getContextPath())) {
			 /*
             * 이전에 로그인하지 않고 나간 SavedRequest가 남아 있으면
             * 현재 returnUrl보다 우선될 수 있으므로 제거한다.
             */
			requestCache.removeRequest(request, response);
			clearLoginReturnAttributes(session);
			
	        session.setAttribute("loginReturnUrl", returnUrl);
	        loginBackUrl = returnUrl;
	        
        /*
         * 2. 댓글 작성 또는 로그인 후 글쓰기로 들어온 경우
         */    
	    } else if(cafeId != null && cafeBoardId != null) {
	    	/*
             * 이 요청은 사용자가 직접 누른 로그인 링크이므로
             * 과거 SavedRequest를 제거한다.
             */
	    	requestCache.removeRequest(request, response);
	    	clearLoginReturnAttributes(session);
	    	
			session.setAttribute("loginReturnCafeId", cafeId);
			session.setAttribute("loginReturnCafeBoardId", cafeBoardId);
			
			String postListUrl = buildPostListUrl(
						                    contextPath,
						                    cafeId,
						                    cafeBoardId
						            );
			
			if (bno != null) {
				/*
                 * 게시글 상세 페이지에서 댓글을 작성하려고
                 * 로그인한 경우
                 */
				session.setAttribute("loginReturnBno", bno);
				loginBackUrl = postListUrl + "/" + bno;
			} else {
				/*
                 * 게시글 목록에서 로그인 후 글쓰기를
                 * 선택한 경우
                 */
				session.removeAttribute("loginReturnBno");
				loginBackUrl = postListUrl;
			}
		
		/*
         * 3. Spring Security가 보호된 주소를 차단하여
         * 로그인 화면으로 보낸 경우
         */
	    } else if (requestCache.getRequest(request, response) != null) {
            /*
             * SavedRequest가 실제 복귀 목적지가 되므로
             * 이전의 수동 로그인 복귀 정보는 제거한다.
             *
             * 보호된 주소로 돌아가기 버튼을 연결하면 다시
             * 로그인 화면으로 되돌아올 수 있으므로,
             * 돌아가기 버튼은 기본 주소인 /cafe를 사용한다.
             */
            clearLoginReturnAttributes(session);

        /*
         * 4. 로그인 실패 후 로그인 화면으로 다시 들어온 경우
         */
	    } else if (request.getParameter("error") != null) {
            /*
             * 실패 전 세션에 저장했던 주소를 다시 사용한다.
             */
            loginBackUrl = resolveLoginBackUrl(session, contextPath);

        /*
         * 5. 주소창에서 로그인 페이지에 직접 들어온 경우,
         * 회원가입 완료 후 로그인 페이지로 온 경우 등
         */    
		} else {
			/*
            * 과거에 로그인 화면을 취소하면서 남은 주소가
            * 다음 로그인에 사용되지 않도록 정리한다.
            */
			clearLoginReturnAttributes(session);
		}
		   
		// 모든 주소 처리가 끝난 뒤 모델에 전달
		model.addAttribute("loginBackUrl", loginBackUrl);
		
		return "member/login";
	}
	
	
	/*
     * 로그인 실패 후 세션에 저장된 정보를 이용해
     * 돌아가기 버튼의 주소를 다시 만든다.
     */
	private String resolveLoginBackUrl(HttpSession session, String contextPath) {
		String savedReturnUrl =
                (String) session.getAttribute(
                        "loginReturnUrl"
                );

        if (isSafeReturnUrl(
                savedReturnUrl,
                contextPath
        )) {
            return savedReturnUrl;
        }

        Long savedCafeId =
                (Long) session.getAttribute(
                        "loginReturnCafeId"
                );

        Long savedCafeBoardId =
                (Long) session.getAttribute(
                        "loginReturnCafeBoardId"
                );

        Long savedBno =
                (Long) session.getAttribute(
                        "loginReturnBno"
                );

        if (savedCafeId != null
                && savedCafeBoardId != null) {

            String postListUrl =
                    buildPostListUrl(
                            contextPath,
                            savedCafeId,
                            savedCafeBoardId
                    );

            if (savedBno != null) {
                return postListUrl
                        + "/"
                        + savedBno;
            }

            return postListUrl;
        }

        return contextPath + "/cafe";
    }

	
    /*
     * 게시글 목록 주소를 한 곳에서 생성한다.
     */
	private String buildPostListUrl(String contextPath, Long cafeId, Long cafeBoardId) {
	    return contextPath
	                + "/cafe/" + cafeId
	                + "/board/" + cafeBoardId
	                + "/post";
    }
	
	
	/*
     * 세션에 남아 있는 로그인 복귀 정보를 모두 제거한다.
     */
	private void clearLoginReturnAttributes(HttpSession session) {
		session.removeAttribute(
                "loginReturnUrl"
        );

        session.removeAttribute(
                "loginReturnCafeId"
        );

        session.removeAttribute(
                "loginReturnCafeBoardId"
        );

        session.removeAttribute(
                "loginReturnBno"
        );
		
	}
	
	
	/*
     * 외부 사이트나 WEB-INF 내부 경로로 이동하지 못하도록
     * 복귀 주소가 현재 애플리케이션 내부 주소인지 검사한다.
     */
	private boolean isSafeReturnUrl(String returnUrl, String contextPath) {
		if (returnUrl == null
				|| returnUrl.trim().isEmpty()
		        || returnUrl.contains("\r")
		        || returnUrl.contains("\n")
		        || returnUrl.contains("\\")
		        || returnUrl.contains("://")
		        || returnUrl.startsWith("//")) {
		    
			return false;
		}
		
		/*
         * 쿼리 문자열을 제외한 실제 경로만 검사한다.
         *
         * 예:
         * /cafe/1/board/1/post?page=2
         * -> /cafe/1/board/1/post
         */
        int queryIndex = returnUrl.indexOf('?');

        String returnPath = 
        		queryIndex >= 0 ? 
        				returnUrl.substring(0, queryIndex) : returnUrl;
		
		String prefix = contextPath.isEmpty() ? "/" : contextPath + "/";
		
	    String loginPagePath = contextPath + "/member/login";
	    
	    String loginProcessingPath = contextPath + "/login";
	    
	    String logoutPath = contextPath + "/logout";
	    
	    String webInfPath = contextPath + "/WEB-INF/";

	    return returnPath.startsWith(prefix)
	            && !returnPath.equals(loginPagePath)
	            && !returnPath.equals(loginProcessingPath)
	            && !returnPath.equals(logoutPath)
	            && !returnPath.startsWith(webInfPath);
	}

	 /*
     * POST /login은 이 컨트롤러가 아니라
     * Spring Security가 처리한다.
     */
	
	
	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("member", new MemberDTO());
		return "member/register";
	}
	
	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("member") MemberDTO memberDTO, BindingResult bindingResult) {
		// @NotBlank 등의 기본 검증 오류
		if(bindingResult.hasErrors()) {
			return "member/register";
		}
		
		try {
			memberService.register(memberDTO);
			
		} catch (DuplicateUsernameException e) {
			bindingResult.rejectValue("username", "duplicate", e.getMessage());
			
			return "member/register";
			
		} catch (PasswordMismatchException e) {
			bindingResult.rejectValue("passwordConfirm", "mismatch", e.getMessage());
			
			return "member/register";
		}
		
		return "redirect:/member/login?registered";
	}
}
