<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<header class="cafe-topbar">
    <div class="container cafe-topbar-inner">

        <!-- 프로젝트 로고 -->
        <a class="cafe-service-logo"
           href="${pageContext.request.contextPath}/cafe">
            DEEP STUDY
        </a>

        <!-- 우측 메뉴 -->
        <nav class="cafe-utility-menu"
             aria-label="사용자 메뉴">

            <c:choose>

                <%-- 비로그인 상태 --%>
                <c:when test="${empty pageContext.request.userPrincipal}">

                    <a href="${pageContext.request.contextPath}/member/login">
                        로그인
                    </a>

                    <a href="${pageContext.request.contextPath}/member/register">
                        가입하기
                    </a>

                </c:when>

                <%-- 로그인 상태 --%>
                <c:otherwise>

                    <span class="cafe-login-user">
                        ${pageContext.request.userPrincipal.name}
                    </span>

                    <form class="cafe-logout-form"
                          method="post"
                          action="${pageContext.request.contextPath}/logout">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <button type="submit">
                            로그아웃
                        </button>
                    </form>

                </c:otherwise>

            </c:choose>

        </nav>
    </div>
</header>