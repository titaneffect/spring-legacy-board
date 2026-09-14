<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${board.title}</title>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

	<form method="post"
		action="${pageContext.request.contextPath}/board/modify">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="hidden" name="bno" value="${board.bno}">
		<input type="hidden" name="page" value="${pageRequest.page}">
		<input type="hidden" name="size" value="${pageRequest.size}">
		<input type="hidden" name="type" value="${pageRequest.type}">
		<input type="hidden" name="keyword" value="${pageRequest.keyword}">
		
		<input type="text" name="title" value="${board.title}">
		<textarea name="content">${board.content}</textarea>
		<input type="hidden" name="writer" value="${board.writer}">
		<button type="submit">수정</button>
	</form>
	
	<c:if test="${not empty errors}">
		<c:forEach var="error" items="${errors}">
			<li>${error.defaultMessage}</li>
		</c:forEach>
	</c:if>
	
	<form method="post"
		action="${pageContext.request.contextPath}/board/remove">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<input type="hidden" name="bno" value="${board.bno}">
		<button type="submit">삭제</button>	
	</form>
	<a href="${pageContext.request.contextPath}/board/list?${pageRequest.link}">
		목록
	</a>
	<a href="${pageContext.request.contextPath}/board/read?bno=${board.bno}&${pageRequest.link}">
		취소
	</a>
</body>
</html>