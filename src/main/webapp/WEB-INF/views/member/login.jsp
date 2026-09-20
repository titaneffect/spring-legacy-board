<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>로그인</title>
	
	<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>
<body>

    <jsp:include
        page="/WEB-INF/views/common/header.jsp"/>

    <main class="container cafe-auth-page">

        <section class="cafe-auth-card">

            <a class="cafe-auth-logo"
               href="${pageContext.request.contextPath}/cafe">
                DEEP STUDY
            </a>

            <h1>
                로그인
            </h1>

            <p class="cafe-auth-description">
                Deep Study Cafe에 로그인하세요.
            </p>

            <!-- 회원가입 성공 -->
            <c:if test="${param.registered != null}">

                <div class="alert alert-success"
                     role="alert">
                    회원가입이 완료되었습니다.
                    로그인해 주세요.
                </div>

            </c:if>

            <!-- 로그인 실패 -->
            <c:if test="${param.error != null}">

                <div class="alert alert-danger"
                     role="alert">
                    아이디 또는 비밀번호가 올바르지 않습니다.
                </div>

            </c:if>

            <!-- 로그아웃 성공 -->
            <c:if test="${param.logout != null}">

                <div class="alert alert-secondary"
                     role="alert">
                    로그아웃되었습니다.
                </div>

            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/login">

                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">

                <div class="mb-3">

                    <label class="form-label fw-semibold"
                           for="username">
                        아이디
                    </label>

                    <input class="form-control"
                           type="text"
                           id="username"
                           name="username"
                           autocomplete="username"
                           placeholder="아이디를 입력하세요"
                           required>

                </div>

                <div class="mb-4">

                    <label class="form-label fw-semibold"
                           for="password">
                        비밀번호
                    </label>

                    <input class="form-control"
                           type="password"
                           id="password"
                           name="password"
                           autocomplete="current-password"
                           placeholder="비밀번호를 입력하세요"
                           required>

                </div>

                <button class="btn cafe-primary-button w-100"
                        type="submit">
                    로그인
                </button>

            </form>

            <div class="cafe-auth-links">

                <span>
                    아직 회원이 아니신가요?
                </span>

                <a href="${pageContext.request.contextPath}/member/register">
                    회원가입
                </a>

            </div>
            
            <c:choose>

			    <%-- 로그아웃 또는 회원가입 완료 후 --%>
			    <c:when test="${param.logout != null or param.registered != null}">
			
			        <a class="cafe-auth-back"
			           href="${pageContext.request.contextPath}/cafe">
			            커뮤니티 홈으로 돌아가기
			        </a>
			
			    </c:when>
			
			    <%-- 이전 페이지에서 로그인 화면으로 들어온 경우 --%>
			    <c:otherwise>
			
			        <a class="cafe-auth-back"
			           href="<c:out value='${loginBackUrl}'/>">
			            이전으로 돌아가기
			        </a>
			
			    </c:otherwise>
			
			</c:choose>

        </section>
    </main>
</body>
</html>