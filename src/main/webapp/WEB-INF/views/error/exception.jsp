<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${exceptionName}</title>
    
    <jsp:include
        page="/WEB-INF/views/common/styles.jsp"/>
</head>
<body>

    <jsp:include
        page="/WEB-INF/views/common/header.jsp"/>

    <%--
        Spring Security Filter에서 직접 403 화면으로 보낸 경우에는
        ControllerAdvice의 Model 값이 없을 수 있으므로 기본값을 사용한다.
    --%>

    <c:set var="displayExceptionName"
           value="${empty exceptionName
                ? '403 FORBIDDEN'
                : exceptionName}"/>

    <c:set var="displayMessage"
           value="${empty message
                ? '요청한 기능을 이용할 권한이 없습니다.'
                : message}"/>

    <main class="container cafe-error-page">

        <section class="cafe-error-card">

            <div class="cafe-error-symbol">
                !
            </div>

            <strong class="cafe-error-code">
                <c:out value="${displayExceptionName}"/>
            </strong>

            <h1>
                요청을 처리할 수 없습니다.
            </h1>

            <p>
                <c:out value="${displayMessage}"/>
            </p>

            <div class="cafe-error-actions">

                <button class="btn btn-outline-secondary"
                        type="button"
                        onclick="history.back();">
                    이전 페이지
                </button>

                <a class="btn cafe-primary-button"
                   href="${pageContext.request.contextPath}/board/list">
                    카페 홈
                </a>

            </div>

        </section>
    </main>
</body>
</html>