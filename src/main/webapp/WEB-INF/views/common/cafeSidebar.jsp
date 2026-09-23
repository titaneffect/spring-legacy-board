<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
    prefix="fn" %>

<aside class="col-lg-3">

    <section class="cafe-sidebar-card">

        <div class="cafe-sidebar-profile">

	        <%-- 왼쪽 카페 아이콘 --%>
	        <div class="cafe-profile-image"
	             aria-hidden="true">
	
	            <svg width="27"
	                 height="27"
	                 viewBox="0 0 24 24"
	                 fill="none"
	                 xmlns="http://www.w3.org/2000/svg">
	
	                <path d="M4 5.5H20V16.5H8L4 20V5.5Z"
	                      stroke="currentColor"
	                      stroke-width="1.8"
	                      stroke-linejoin="round"/>
	
	                <path d="M8 9H16M8 12.5H14"
	                      stroke="currentColor"
	                      stroke-width="1.8"
	                      stroke-linecap="round"/>
	            </svg>
	
	        </div>
	
	        <%-- 오른쪽 카페 정보 --%>
	        <div class="cafe-profile-content">
	
	            <div class="cafe-owner">
	                <strong>
	                    <c:out value="${cafe.ownerUsername}"/>
	                </strong>
	
	                <span class="cafe-owner-badge">
	                    매니저
	                </span>
	            </div>
	
	            <div class="cafe-created-date">
	                <c:out value="${cafeCreatedDate}"/> 개설
	            </div>
	
	        </div>
	
	    </div>
	    
	    <%-- 프로필 정보와 글쓰기 버튼 사이 구분선 --%>
    	<div class="cafe-sidebar-divider"></div>

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

        <c:forEach var="menuBoard" items="${cafeBoardList}">
		    <a class="cafe-sidebar-link ${menuBoard.cafeBoardId eq cafeBoard.cafeBoardId ? 'active' : ''}"
		       href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${menuBoard.cafeBoardId}/post">
		        <c:out value="${menuBoard.boardName}"/>
		    </a>
		</c:forEach>

    </nav>

</aside>