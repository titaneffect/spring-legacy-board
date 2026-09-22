<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
 	prefix="fn" %>

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
                
                	<%--
					    JSP 내부 경로가 아니라
					    사용자가 요청한 원래 URI를 가져온다.
					--%>
					<c:set var="headerReturnUri"
					       value="${requestScope['javax.servlet.forward.request_uri']}"/>
					
					<c:set var="headerReturnQuery"
					       value="${requestScope['javax.servlet.forward.query_string']}"/>
					
					<%-- forward 정보가 없는 경우를 위한 예비 처리 --%>
					<c:if test="${empty headerReturnUri}">
					
					    <c:set var="headerReturnUri"
					           value="${pageContext.request.requestURI}"/>
					
					    <c:set var="headerReturnQuery"
					           value="${pageContext.request.queryString}"/>
					
					</c:if>
					
					<%-- URI를 기준으로 최종 복귀 주소를 만든다. --%>
					<c:set var="headerReturnUrl"
					       value="${headerReturnUri}"/>
					
					<%-- 페이지 번호와 검색 조건을 복귀 주소에 포함한다. --%>
					<c:if test="${not empty headerReturnQuery}">
					
					    <c:set var="headerReturnUrl"
					           value="${headerReturnUrl}?${headerReturnQuery}"/>
					
					</c:if>
					
					<c:set var="loginPageUri"
					       value="${pageContext.request.contextPath}/member/login"/>

                    <%--
                        로그인 화면에서 로그인 링크를 다시 누르면
                        자기 자신으로 돌아오는 주소가 생기므로
                        로그인 페이지에서는 로그인 링크를 숨긴다.
                    --%>
					<c:if test="${headerReturnUri ne loginPageUri}">

                        <c:url var="loginUrl"
                               value="/member/login">

                            <c:param name="returnUrl"
                                     value="${headerReturnUrl}"/>

                        </c:url>

                        <a href="${fn:escapeXml(loginUrl)}">
                            로그인
                        </a>

                    </c:if>

                    <a href="${pageContext.request.contextPath}/member/register">
                        가입하기
                    </a>

                </c:when>

                <%-- 로그인 상태 --%>
                <c:otherwise>

                    <span class="cafe-login-user">
                        ${fn:escapeXml(pageContext.request.userPrincipal.name)}
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