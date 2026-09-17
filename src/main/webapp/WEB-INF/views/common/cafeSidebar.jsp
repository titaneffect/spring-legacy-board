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
            <c:when test="${not empty pageContext.request.userPrincipal}">

                <a class="cafe-write-button mt-3"
                   href="${pageContext.request.contextPath}/board/register">
                    카페 글쓰기
                </a>

            </c:when>

            <c:otherwise>

                <a class="cafe-write-button mt-3"
                   href="${pageContext.request.contextPath}/member/login">
                    로그인하고 글쓰기
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
           href="${pageContext.request.contextPath}/board/list">
            전체글보기
        </a>

    </nav>

</aside>