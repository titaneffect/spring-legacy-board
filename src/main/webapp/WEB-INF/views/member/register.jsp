<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	
	<h1>회원가입</h1>
	
	<form:form method="post" action="${pageContext.request.contextPath}/member/register"
        modelAttribute="member">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        <div>
        	<label for="username">아이디</label>
        	<form:input id="username" path="username" />
        	<form:errors path="username" />
        </div>
        <div>
        	<label for="password">비밀번호</label>
        	<form:password id="password" path="password" />
        	<form:errors path="password" />
        </div>
        <div>
        	<label for="passwordConfirm">비밀번호 확인</label>
        	<form:password id="passwordConfirm" path="passwordConfirm" />
        	<form:errors path="passwordConfirm" />
        </div>
        <button type="submit">가입</button>
        <a href="${pageContext.request.contextPath}/board/list">
        	취소
        </a>
	</form:form>	
</body>
</html>