<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${cafe.cafeName}"/></title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

    <section class="border rounded-3 bg-white p-5 mb-4">

        <div class="small text-success fw-semibold mb-2">
            CAFE
        </div>

        <h1 class="display-6 fw-bold mb-3">
            <c:out value="${cafe.cafeName}"/>
        </h1>

        <p class="lead text-muted mb-4">
            <c:choose>
                <c:when test="${not empty cafe.description}">
                    <c:out value="${cafe.description}"/>
                </c:when>

                <c:otherwise>
                    등록된 카페 소개가 없습니다.
                </c:otherwise>
            </c:choose>
        </p>

        <div class="d-flex gap-3 align-items-center">
            <span class="badge text-bg-success">
                <c:out value="${cafe.status}"/>
            </span>

            <span class="text-muted">
                운영자:
                <strong>
                    <c:out value="${cafe.ownerUsername}"/>
                </strong>
            </span>
        </div>

    </section>

    <div class="row g-4">

        <div class="col-lg-8">
            <section class="cafe-board-panel">

                <div class="d-flex
            justify-content-between
            align-items-center
            gap-3">
	
				    <div class="cafe-board-title">
					        카페 게시판
				    </div>
				
				    <c:if test="${not empty pageContext.request.userPrincipal
				                  and pageContext.request.userPrincipal.name
				                      eq cafe.ownerUsername}">
				
				        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/register"
				           class="btn btn-sm cafe-primary-button">
				            게시판 만들기
				        </a>
				
				    </c:if>
				
				</div>
				
				<c:choose>
				
				    <c:when test="${empty cafeBoardList}">
				        <div class="text-center text-muted py-5">
				            아직 만들어진 게시판이 없습니다.
				        </div>
				    </c:when>
				
				    <c:otherwise>
				
				        <div class="list-group list-group-flush mt-3">
				
				            <c:forEach var="cafeBoard"
				                       items="${cafeBoardList}">
				
				                <div class="list-group-item px-0 py-3">
				
				                    <div class="d-flex
				                                justify-content-between
				                                align-items-center
				                                gap-3">
				
				                        <div>
				                        	<a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/post">
					                            <strong class="d-block mb-1">
					                                <c:out value="${cafeBoard.boardName}"/>
					                            </strong>
											</a>
				                            <span class="small text-muted">
				                                읽기:
				                                <c:out value="${cafeBoard.readRole}"/>
				
				                                · 쓰기:
				                                <c:out value="${cafeBoard.writeRole}"/>
				                            </span>
				                        </div>
				
				                        <div class="d-flex
										            align-items-center
										            flex-wrap
										            gap-2">
										
										    <c:choose>
										
										        <c:when test="${cafeBoard.boardType eq 'NOTICE'}">
										            <span class="badge text-bg-success">
										                공지
										            </span>
										        </c:when>
										
										        <c:otherwise>
										            <span class="badge text-bg-light">
										                일반
										            </span>
										        </c:otherwise>
										
										    </c:choose>
										
										    <c:if test="${not empty pageContext.request.userPrincipal
										                  and pageContext.request.userPrincipal.name
										                      eq cafe.ownerUsername}">
										
										        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/modify"
										           class="btn btn-sm btn-outline-secondary">
										            관리
										        </a>
										
										    </c:if>
										
										</div>
				
				                    </div>
				                </div>
				
				            </c:forEach>
				
				        </div>
				
				    </c:otherwise>
				
				</c:choose>

            </section>
        </div>

        <div class="col-lg-4">
            <section class="border rounded-3 bg-white p-4">

                <h2 class="h5 mb-3">카페 정보</h2>

                <dl class="mb-0">
                    <dt class="small text-muted mb-1">
                        카페 번호
                    </dt>
                    <dd class="mb-3">
                        <c:out value="${cafe.cafeId}"/>
                    </dd>

                    <dt class="small text-muted mb-1">
                        운영자
                    </dt>
                    <dd class="mb-0">
                        <c:out value="${cafe.ownerUsername}"/>
                    </dd>
                </dl>

            </section>
        </div>

    </div>

    <div class="mt-4 d-flex flex-wrap align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/cafe"
           class="btn btn-outline-secondary">
            카페 목록
        </a>
        <c:if test="${not empty pageContext.request.userPrincipal
                  and pageContext.request.userPrincipal.name
                      eq cafe.ownerUsername}">

	        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/modify"
	           class="btn btn-outline-success">
	            카페 수정
	        </a>
	        
	        <form method="post"
		          action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/remove"
		          class="d-inline"
		          onsubmit="return confirm('정말 이 카페를 삭제하시겠습니까?');">
		
		        <input type="hidden"
		               name="${_csrf.parameterName}"
		               value="${_csrf.token}">
		
		        <button type="submit"
		                class="btn btn-outline-danger">
		            카페 삭제
		        </button>
    		</form>
    	</c:if>
    </div>
</main>

</body>
</html>