<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
    prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카페 목록</title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

    <div class="d-flex justify-content-between
                align-items-center mb-4">

        <div>
            <h1 class="h3 mb-2">카페 둘러보기</h1>

            <p class="text-muted mb-0">
                관심 있는 카페를 찾아 참여해보세요.
            </p>
        </div>

        <c:if test="${not empty pageContext.request.userPrincipal}">
		    <a href="${pageContext.request.contextPath}/cafe/register"
		       class="btn cafe-primary-button">
		        카페 만들기
		    </a>
		</c:if>
    </div>

    <c:choose>

        <c:when test="${empty cafeList}">
            <div class="border rounded-3 bg-white
                        text-center py-5">

                <h2 class="h5 mb-3">
                    아직 등록된 카페가 없습니다.
                </h2>

                <p class="text-muted mb-4">
                    첫 번째 카페를 만들어보세요.
                </p>
				<c:if test="${not empty pageContext.request.userPrincipal}">
	                <a href="${pageContext.request.contextPath}/cafe/register"
	                   class="btn cafe-primary-button">
	                    카페 만들기
	                </a>
	            </c:if>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row g-4">

                <c:forEach var="cafe" items="${cafeList}">
                    <div class="col-md-6 col-lg-4">

                        <article class="card h-100 shadow-sm border-0">

                            <div class="card-body p-4">

                                <div class="small text-success fw-semibold mb-2">
                                    ACTIVE CAFE
                                </div>

                                <h2 class="h5 mb-3">
                                    <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}"
                                       class="text-decoration-none text-dark">

                                        <c:out value="${cafe.cafeName}"/>
                                    </a>
                                </h2>

                                <p class="text-muted mb-4">
                                    <c:choose>
                                        <c:when test="${not empty cafe.description}">
                                            <c:out value="${cafe.description}"/>
                                        </c:when>

                                        <c:otherwise>
                                            등록된 카페 소개가 없습니다.
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <div class="small text-muted">
                                    운영자:
                                    <c:out value="${cafe.ownerUsername}"/>
                                </div>

                            </div>

                            <div class="card-footer bg-white border-0 px-4 pb-4">

                                <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}"
                                   class="btn btn-outline-success w-100">
                                    카페 방문하기
                                </a>

                            </div>

                        </article>

                    </div>
                </c:forEach>

            </div>
        </c:otherwise>

    </c:choose>

</main>

</body>
</html>