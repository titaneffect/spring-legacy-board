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
    <c:if test="${empty pageContext.request.userPrincipal}">
		<a href="${pageContext.request.contextPath}/member/login?bno=${board.bno}">
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

	<h1>${board.title}</h1>
	
	<p>번호: ${board.bno}</p>
	<p>작성자: ${board.writer}</p>
	<p>내용: ${board.content}</p>
	
	<a href="${pageContext.request.contextPath}/board/list?&${pageRequest.link}">
		목록
	</a>
	<c:if test="${not empty pageContext.request.userPrincipal and pageContext.request.userPrincipal.name eq board.writer}">
		<a href="${pageContext.request.contextPath}/board/modify?bno=${board.bno}&${pageRequest.link}">
			수정
		</a>
	</c:if>

	<c:choose>
		<c:when test="${not empty pageContext.request.userPrincipal}">
			<form method="post" action="${pageContext.request.contextPath}/reply/register">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				<input type="hidden" name="bno" value="${board.bno}">
				<input type="hidden" name="page" value="${pageRequest.page}">
				<input type="hidden" name="size" value="${pageRequest.size}">
				<input type="hidden" name="type" value="${pageRequest.type}">
				<input type="hidden" name="keyword" value="${pageRequest.keyword}">
				
				<textarea name="reply">${replyInputRegister.reply}</textarea>
				<input type="hidden" name="replyer" value="${pageContext.request.userPrincipal.name}">
				<button type="submit">댓글 등록</button>
			</form>
		</c:when>
		
		<c:otherwise>
			<p>댓글을 작성하려면 로그인이 필요합니다.</p>
		</c:otherwise>
	</c:choose>
	
	
	<c:if test="${not empty registerErrors}">
		<c:forEach var="error" items="${registerErrors}">
			<li>${error.defaultMessage}</li>
		</c:forEach>
	</c:if>
	
	<h3>댓글</h3>
	<c:forEach var="reply" items="${replyList}">
		<div>
			<c:set var="isModifyError"
				value="${not empty replyInputModify and replyInputModify.rno eq reply.rno}"/>
			<div>
				<span>${reply.rno}.</span>
				<span>${reply.reply}</span>
			</div>
			<span>${reply.replyer}</span>
			<span>${reply.modDate}</span>
			<c:if test="${not empty pageContext.request.userPrincipal and pageContext.request.userPrincipal.name eq reply.replyer}">
				<details ${isModifyError ? 'open' : ''}>
					<summary>수정</summary>
					<form method="post" action="${pageContext.request.contextPath}/reply/modify">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<input type="hidden" name="rno" value="${reply.rno}">
						<input type="hidden" name="bno" value="${reply.bno}">
						<input type="hidden" name="page" value="${pageRequest.page}">
						<input type="hidden" name="size" value="${pageRequest.size}">
						<input type="hidden" name="type" value="${pageRequest.type}">
						<input type="hidden" name="keyword" value="${pageRequest.keyword}">
						
						<textarea name="reply">${isModifyError ? replyInputModify.reply : reply.reply}</textarea>
						<input type="hidden" name="replyer" 
							value="${isModifyError ? replyInputModify.replyer : reply.replyer}">
						
						<c:if test="${isModifyError and not empty modifyErrors}">
							<c:forEach var="error" items="${modifyErrors}">
	                        	<li>${error.defaultMessage}</li>
	                    	</c:forEach>
						</c:if>
						
						<button type="submit">수정</button>
					</form>
									
					<form method="post" action="${pageContext.request.contextPath}/reply/remove">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						<input type="hidden" name="rno" value="${reply.rno}">
						<input type="hidden" name="bno" value="${reply.bno}">
						<input type="hidden" name="page" value="${pageRequest.page}">
						<input type="hidden" name="size" value="${pageRequest.size}">
						<input type="hidden" name="type" value="${pageRequest.type}">
						<input type="hidden" name="keyword" value="${pageRequest.keyword}">
						<button type="submit">삭제</button>
					</form>
				</details>
			</c:if>
		</div>
	</c:forEach>
	
</body>
</html>