<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 등록</title>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp"/>

	<form method="post" enctype="multipart/form-data"
      action="${pageContext.request.contextPath}/board/register">
	    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	    <input type="text" name="title" value="${board.title}">
	    <textarea name="content">${board.content}</textarea>
	    <input type="hidden" name="writer" value="${pageContext.request.userPrincipal.name}">
	    <input type="file" id="uploadFiles" name="uploadFiles" multiple>
	    
	    <c:if test="${not empty errors}">
	    	<c:forEach var="error" items="${errors}">
	    		<li>${error.defaultMessage}</li>
	    	</c:forEach>    	
	    </c:if>
	    
	    <button type="submit">등록</button>
	    <a href="${pageContext.request.contextPath}/board/list">
	    	취소
	    </a>
	</form>
</body>
</html>