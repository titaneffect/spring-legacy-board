<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<%@ taglib uri="http://www.springframework.org/tags/form"
    prefix="form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카페 게시판 만들기</title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

    <div class="row justify-content-center">
        <div class="col-lg-8">

            <section class="cafe-form-panel">

                <header class="cafe-form-header">

                    <span class="cafe-form-category">
                        <c:out value="${cafe.cafeName}"/>
                    </span>

                    <h1>카페 게시판 만들기</h1>

                    <p>
                        카페에서 사용할 게시판의 이름과
                        접근 권한을 설정하세요.
                    </p>

                </header>

                <form:form
                    method="post"
                    modelAttribute="cafeBoard"
                    action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/register">

                    <form:hidden path="displayOrder"/>

                    <div class="mb-4">

                        <label for="boardName"
                               class="form-label fw-semibold">
                            게시판 이름
                        </label>

                        <form:input
                            path="boardName"
                            id="boardName"
                            cssClass="form-control"
                            maxlength="50"
                            placeholder="게시판 이름을 입력하세요"/>

                        <form:errors
                            path="boardName"
                            cssClass="text-danger small d-block mt-2"/>

                    </div>

                    <div class="mb-4">

                        <label for="boardType"
                               class="form-label fw-semibold">
                            게시판 유형
                        </label>

                        <form:select
                            path="boardType"
                            id="boardType"
                            cssClass="form-select">

                            <form:options items="${boardTypes}"/>

                        </form:select>

                        <form:errors
                            path="boardType"
                            cssClass="text-danger small d-block mt-2"/>

                        <div class="form-text">
                            GENERAL은 일반 게시판,
                            NOTICE는 공지 게시판입니다.
                        </div>

                    </div>

                    <div class="row g-3 mb-4">

                        <div class="col-md-6">

                            <label for="readRole"
                                   class="form-label fw-semibold">
                                읽기 권한
                            </label>

                            <form:select
                                path="readRole"
                                id="readRole"
                                cssClass="form-select">

                                <form:options items="${readLevels}"/>

                            </form:select>

                            <form:errors
                                path="readRole"
                                cssClass="text-danger small d-block mt-2"/>

                            <div class="form-text">
                                이 등급 이상의 사용자만
                                게시글을 읽을 수 있습니다.
                            </div>

                        </div>

                        <div class="col-md-6">

                            <label for="writeRole"
                                   class="form-label fw-semibold">
                                쓰기 권한
                            </label>

                            <form:select
                                path="writeRole"
                                id="writeRole"
                                cssClass="form-select">

                                <form:options items="${writeLevels}"/>

                            </form:select>

                            <form:errors
                                path="writeRole"
                                cssClass="text-danger small d-block mt-2"/>

                            <div class="form-text">
                                비회원에게는 글쓰기 권한을
                                부여할 수 없습니다.
                            </div>

                        </div>

                    </div>

                    <div class="cafe-form-actions">

                        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}"
                           class="btn btn-outline-secondary">
                            취소
                        </a>

                        <button type="submit"
                                class="btn cafe-primary-button">
                            게시판 만들기
                        </button>

                    </div>

                </form:form>

            </section>

        </div>
    </div>

</main>

</body>
</html>