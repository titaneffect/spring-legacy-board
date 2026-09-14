<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header>    
    <c:if test="${empty pageContext.request.userPrincipal}">
		<a href="${pageContext.request.contextPath}/member/login">
			로그인
		</a>
		<a href="${pageContext.request.contextPath}/member/register">
			회원가입
		</a>
	</c:if>

    <c:if test="${not empty pageContext.request.userPrincipal}">
        <span>
            ${pageContext.request.userPrincipal.name}
        </span>

        <form method="post"
              action="${pageContext.request.contextPath}/logout">

            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">

            <button type="submit">로그아웃</button>
        </form>
    </c:if>
</header>