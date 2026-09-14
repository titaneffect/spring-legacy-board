<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
</head>
<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	
	
	
	<form method="get" action="${pageContext.request.contextPath}/board/list">
		<select name="type">
			<option value="T" ${pageRequest.type == "T" ? 'selected' : ''}>
				제목
			</option>
			<option value="W" ${pageRequest.type == "W" ? 'selected' : ''}>
				작성자
			</option>
			<option value="C" ${pageRequest.type == "C" ? 'selected' : ''}>
				내용
			</option>
		</select>
		<input type="text" name="keyword" value="${pageRequest.keyword}">
		<input type="hidden" name="size" value="${pageResponse.size}">
		<button type="submit">검색</button>
	</form>
	<c:forEach var="board" items="${pageResponse.dtoList}">
	    <div>
	        ${board.bno}
	        <a href="${pageContext.request.contextPath}/board/read?bno=${board.bno}&${pageRequest.link}">
	        	${board.title}
	        </a>
	        ${board.writer}
	        ${board.regDate}
	    </div>
	</c:forEach>
    <a href="${pageContext.request.contextPath}/board/register?${pageRequest.link}">
    	등록
    </a>
    <div class="pagination">
    	<c:if test="${pageResponse.prev}">
    		<a href="${pageContext.request.contextPath}/board/list?page=${pageResponse.start - 1}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
    			이전
    		</a>
    	</c:if>
    	<c:forEach var="pageNum"
    		begin="${pageResponse.start}" end="${pageResponse.end}">
    		<c:choose>
    			<c:when test="${pageNum == pageResponse.page}">
    				<strong>${pageNum}</strong>
    			</c:when>
    			<c:otherwise>
    				<a href="${pageContext.request.contextPath}/board/list?page=${pageNum}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
    					${pageNum}
    				</a>
    			</c:otherwise>
			</c:choose>
    	</c:forEach>
    	<c:if test="${pageResponse.next}">
    		<a href="${pageContext.request.contextPath}/board/list?page=${pageResponse.end + 1}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
    			다음
    		</a>
    	</c:if>
    </div>
</body>
</html>