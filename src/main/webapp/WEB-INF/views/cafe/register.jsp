<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://www.springframework.org/tags/form"
    prefix="form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카페 만들기</title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

    <div class="row justify-content-center">
        <div class="col-lg-8">

            <section class="cafe-form-panel">

                <div class="cafe-form-header">
                    <div>
                        <div class="cafe-form-category">
                            새로운 커뮤니티
                        </div>

                        <h1 class="h3 mb-2">
                            카페 만들기
                        </h1>

                        <p class="text-muted mb-0">
                            관심사를 함께 나눌 새로운 카페를 만들어보세요.
                        </p>
                    </div>
                </div>

                <form:form
                    method="post"
                    modelAttribute="cafe"
                    action="${pageContext.request.contextPath}/cafe/register">

                    <div class="mb-4">
                        <label for="cafeName"
                               class="form-label fw-semibold">
                            카페 이름
                        </label>

                        <form:input
                            path="cafeName"
                            id="cafeName"
                            cssClass="form-control"
                            maxlength="100"
                            placeholder="카페 이름을 입력하세요"/>

                        <form:errors
                            path="cafeName"
                            cssClass="text-danger small d-block mt-2"/>
                    </div>

                    <div class="mb-4">
                        <label for="description"
                               class="form-label fw-semibold">
                            카페 소개
                        </label>

                        <form:textarea
                            path="description"
                            id="description"
                            cssClass="form-control"
                            rows="7"
                            maxlength="500"
                            placeholder="카페를 소개하는 내용을 입력하세요"/>

                        <form:errors
                            path="description"
                            cssClass="text-danger small d-block mt-2"/>
                    </div>

                    <div class="cafe-form-actions">
                        <a href="${pageContext.request.contextPath}/cafe"
                           class="btn btn-outline-secondary">
                            취소
                        </a>

                        <button type="submit"
                                class="btn cafe-primary-button">
                            카페 만들기
                        </button>
                    </div>

                </form:form>

            </section>

        </div>
    </div>

</main>

</body>
</html>