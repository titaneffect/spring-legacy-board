<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	 
	 <h1>로그인</h1>
	 
	 <c:if test="${param.registered != null}">
	    <p>회원가입이 완료되었습니다. 로그인해 주세요.</p>
	</c:if>
	 
	 <c:if test="${param.error != null}">
	 	<p>아이디 또는 비밀번호가 올바르지 않습니다.</p>
	 </c:if>
	 
	 <c:if test="${param.logout != null}">
	 	<p>로그아웃되었습니다.</p>
	 </c:if>
	 
	 <form method="post" action="${pageContext.request.contextPath}/login">
	 	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	 	<div>
	 		<label for="username">아이디</label>
	 		<input type="text" id="username" name="username">
	 	</div>
	 	<div>
	 		<label for="password">비밀번호</label>
	 		<input type="password" id="password" name="password">
	 	</div>
	 	<button type="submit">로그인</button>
	 </form>
	 
	 <a href="${pageContext.request.contextPath}/member/register">
	 	회원가입
	 </a>
	 <a href="${pageContext.request.contextPath}/board/list">
	 	목록
	 </a>
</body>
</html>