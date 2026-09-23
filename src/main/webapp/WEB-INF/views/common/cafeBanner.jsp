<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<section class="cafe-banner mb-4">
    <div class="cafe-banner-content">

        <span class="cafe-banner-label">
            Deep Study Cafe Community
        </span>

        <h1 class="cafe-banner-title">
		    <c:out value="${cafe.cafeName}"/>
		</h1>
		
		<p class="cafe-banner-description">
		    <c:choose>
		        <c:when test="${not empty cafe.description}">
		            <c:out value="${cafe.description}"/>
		        </c:when>
		
		        <c:otherwise>
		            카페 소개가 없습니다.
		        </c:otherwise>
		    </c:choose>
</p>

    </div>
</section>