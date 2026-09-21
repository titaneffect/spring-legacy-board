<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<aside class="col-lg-3">

    <section class="cafe-sidebar-card">

        <div class="cafe-profile-image">
            DS
        </div>

        <div class="mt-3">
            <strong class="d-block">
                Deep Study
            </strong>

            <span class="text-secondary small">
                Spring Legacy Study
            </span>
        </div>

        <c:choose>

		    <%-- 글쓰기 권한 있음 --%>
		    <c:when test="${canWrite}">
		        <a class="cafe-write-button mt-3"
		           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/register">
		            카페 글쓰기
		        </a>
		    </c:when>
		
		    <%-- 비로그인 사용자: 클릭하면 Spring Security가 로그인으로 이동 --%>
		    <c:when test="${empty pageContext.request.userPrincipal}">
		        <a class="cafe-write-button mt-3"
		           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/register">
		            로그인 후 글쓰기
		        </a>
		    </c:when>
		
		    <%-- 로그인했지만 카페 등급이 부족함 --%>
		    <c:otherwise>
		        <a class="cafe-write-button mt-3">
		            글쓰기 권한 없음
		        </a>
		    </c:otherwise>
		
		</c:choose>

    </section>

    <nav class="cafe-sidebar-menu mt-3"
         aria-label="게시판 메뉴">

        <h2 class="cafe-sidebar-title">
            게시판
        </h2>

        <a class="cafe-sidebar-link active"
           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post">
            전체글보기
        </a>

    </nav>

</aside>