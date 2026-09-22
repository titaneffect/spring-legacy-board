<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시판</title>
	
    <jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	
	<main class="container main-content py-4">

	    <!-- 카페 대표 배너 -->
	    <jsp:include page="/WEB-INF/views/common/cafeBanner.jsp"/>	
	    
	    <div class="row g-4 align-items-start">
	
	        <!-- 왼쪽 사이드바 -->
	        <jsp:include page="/WEB-INF/views/common/cafeSidebar.jsp"/>
	
	        <!-- 오른쪽 본문 -->
	        <section class="col-lg-9">
	
	            <!-- 환영 영역 -->
	            <section class="cafe-welcome mb-4">
	
	                <h2>
	                    카페에 오신 것을 환영합니다.
	                </h2>
	
	                <p>
	                    배운 내용을 기록하고 질문과 답변을 나눠보세요.
	                </p>
	
	            </section>
	
	            <!-- 게시글 영역 -->
	            <section class="cafe-board-panel">
	
	                <div class="d-flex flex-wrap
	                            align-items-center
	                            justify-content-between
	                            gap-3 mb-3">
	
	                    <h2 class="cafe-board-title mb-0">
						    <c:out value="${cafeBoard.boardName}"/>
						</h2>
	
	                    <span class="text-secondary small">
	                        총 ${pageResponse.total}개의 글
	                    </span>
	                </div>
	
	                <!-- 검색 -->
	                <form class="row g-2 mb-4"
	                      method="get"
	                      action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post">
	
	                    <div class="col-sm-3">
	
	                        <select class="form-select"
	                                name="type">
	
	                            <option value="T"
	                                ${pageRequest.type == "T"
	                                    ? 'selected' : ''}>
	                                제목
	                            </option>
	
	                            <option value="W"
	                                ${pageRequest.type == "W"
	                                    ? 'selected' : ''}>
	                                작성자
	                            </option>
	
	                            <option value="C"
	                                ${pageRequest.type == "C"
	                                    ? 'selected' : ''}>
	                                내용
	                            </option>
	
	                        </select>
	                    </div>
	
	                    <div class="col">
	
	                        <input class="form-control"
	                               type="text"
	                               name="keyword"
	                               value="${pageRequest.keyword}"
	                               placeholder="검색어를 입력하세요">
	
	                        <input type="hidden"
	                               name="size"
	                               value="${pageResponse.size}">
	                    </div>
	
	                    <div class="col-auto">
	
	                        <button class="btn cafe-search-button"
	                                type="submit">
	                            검색
	                        </button>
	
	                    </div>
	                </form>
	
	                <!-- 게시글 목록 -->
	                <div class="table-responsive">
	
	                    <table class="table
	                                  table-hover
	                                  align-middle
	                                  cafe-board-table">
	
	                        <thead>
	                            <tr>
	                                <th class="text-center">
	                                    번호
	                                </th>
	
	                                <th>
	                                    제목
	                                </th>
	
	                                <th>
	                                    작성자
	                                </th>
	
	                                <th class="text-center">
	                                    등록일
	                                </th>
	                            </tr>
	                        </thead>
	
	                        <tbody>
	
	                            <c:forEach var="board"
	                                       items="${pageResponse.dtoList}">
	
	                                <tr>
	                                    <td class="text-center text-secondary">
	                                        ${board.bno}
	                                    </td>
	
	                                    <td>
	                                        <a class="board-title-link"
	                                           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}?${pageRequest.link}">
	                                            <c:out value="${board.title}"/>
	                                        </a>
	                                    </td>
	
	                                    <td>
	                                        ${board.writer}
	                                    </td>
	
	                                    <td class="text-center
	                                               text-secondary
	                                               text-nowrap">
	                                        ${fn:substring(board.regDate, 0, 10)}
	                                    </td>
	                                </tr>
	
	                            </c:forEach>
	
	                            <c:if test="${empty pageResponse.dtoList}">
	                                <tr>
	                                    <td class="text-center
	                                               text-secondary
	                                               py-5"
	                                        colspan="4">
	                                        등록된 게시글이 없습니다.
	                                    </td>
	                                </tr>
	                            </c:if>
	
	                        </tbody>
	                    </table>
	                </div>
	
	                <!-- 페이지네이션 -->
	                <nav class="mt-4"
	                     aria-label="게시글 페이지">
	
	                    <ul class="pagination
	                               pagination-sm
	                               justify-content-center">
	
	                        <c:if test="${pageResponse.prev}">
	                            <li class="page-item">
	
	                                <a class="page-link"
	                                   href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post?page=${pageResponse.start - 1}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
	                                    이전
	                                </a>
	
	                            </li>
	                        </c:if>
	
	                        <c:forEach var="pageNum"
	                                   begin="${pageResponse.start}"
	                                   end="${pageResponse.end}">
	
	                            <c:choose>
	
	                                <c:when test="${pageNum == pageResponse.page}">
	                                    <li class="page-item active">
	                                        <span class="page-link">
	                                            ${pageNum}
	                                        </span>
	                                    </li>
	                                </c:when>
	
	                                <c:otherwise>
	                                    <li class="page-item">
	
	                                        <a class="page-link"
	                                           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post?page=${pageNum}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
	                                            ${pageNum}
	                                        </a>
	
	                                    </li>
	                                </c:otherwise>
	
	                            </c:choose>
	                        </c:forEach>
	
	                        <c:if test="${pageResponse.next}">
	                            <li class="page-item">
	
	                                <a class="page-link"
	                                   href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post?page=${pageResponse.end + 1}&size=${pageResponse.size}&type=${pageRequest.type}&keyword=${pageRequest.keyword}">
	                                    다음
	                                </a>
	
	                            </li>
	                        </c:if>
	
	                    </ul>
	                </nav>
	
	            </section>
	        </section>
	    </div>
	</main>
	
    
    <script
    	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js">
	</script>
</body>
</html>