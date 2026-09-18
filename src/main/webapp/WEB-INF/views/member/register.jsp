<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	
	<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>
<body>

    <jsp:include
        page="/WEB-INF/views/common/header.jsp"/>

    <main class="container cafe-auth-page">

        <section class="cafe-auth-card">

            <a class="cafe-auth-logo"
               href="${pageContext.request.contextPath}/board/list">
                DEEP STUDY
            </a>

            <h1>
                회원가입
            </h1>

            <p class="cafe-auth-description">
                계정을 만들고 학습 이야기를 나눠보세요.
            </p>

            <form:form
                method="post"
                action="${pageContext.request.contextPath}/member/register"
                modelAttribute="member">

                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">

                <!-- 아이디 -->
                <div class="mb-3">

                    <label class="form-label fw-semibold"
                           for="username">
                        아이디
                    </label>

                    <form:input
                        id="username"
                        path="username"
                        cssClass="form-control"
                        autocomplete="username"
                        placeholder="사용할 아이디를 입력하세요"/>

                    <form:errors
                        path="username"
                        cssClass="invalid-feedback d-block"/>

                </div>

                <!-- 비밀번호 -->
                <div class="mb-3">

                    <label class="form-label fw-semibold"
                           for="password">
                        비밀번호
                    </label>

                    <form:password
                        id="password"
                        path="password"
                        cssClass="form-control"
                        autocomplete="new-password"
                        placeholder="비밀번호를 입력하세요"/>

                    <form:errors
                        path="password"
                        cssClass="invalid-feedback d-block"/>

                </div>

                <!-- 비밀번호 확인 -->
                <div class="mb-4">

                    <label class="form-label fw-semibold"
                           for="passwordConfirm">
                        비밀번호 확인
                    </label>

                    <form:password
                        id="passwordConfirm"
                        path="passwordConfirm"
                        cssClass="form-control"
                        autocomplete="new-password"
                        placeholder="비밀번호를 다시 입력하세요"/>

                    <form:errors
                        path="passwordConfirm"
                        cssClass="invalid-feedback d-block"/>

                </div>

                <button class="btn cafe-primary-button w-100"
                        type="submit">
                    가입하기
                </button>

            </form:form>

            <div class="cafe-auth-links">

                <span>
                    이미 회원이신가요?
                </span>

                <a href="${pageContext.request.contextPath}/member/login">
                    로그인
                </a>

            </div>

            <a class="cafe-auth-back"
               href="${pageContext.request.contextPath}/cafe">
                커뮤니티 홈으로 돌아가기
            </a>

        </section>
    </main>
</body>
</html>