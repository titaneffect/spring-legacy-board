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
<title>카페 게시판 수정</title>

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

                    <h1>카페 게시판 수정</h1>

                    <p>
                        게시판 이름과 접근 권한을 수정할 수 있습니다.
                    </p>

                </header>

                <form:form
                    method="post"
                    modelAttribute="cafeBoard"
                    action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/modify">

                    <div class="mb-4">

                        <label for="boardName"
                               class="form-label fw-semibold">
                            게시판 이름
                        </label>

                        <form:input
                            path="boardName"
                            id="boardName"
                            cssClass="form-control"
                            maxlength="50"/>

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

                        </div>

                    </div>

                    <div class="mb-4">

                        <label for="displayOrder"
                               class="form-label fw-semibold">
                            표시 순서
                        </label>

                        <form:input
                            path="displayOrder"
                            id="displayOrder"
                            type="number"
                            min="0"
                            cssClass="form-control"/>

                        <form:errors
                            path="displayOrder"
                            cssClass="text-danger small d-block mt-2"/>

                        <div class="form-text">
                            숫자가 작은 게시판부터 먼저 표시됩니다.
                        </div>

                    </div>

                    <div class="cafe-form-actions">

                        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}"
                           class="btn btn-outline-secondary">
                            취소
                        </a>

                        <button type="submit"
                                class="btn cafe-primary-button">
                            수정 완료
                        </button>

                    </div>

                </form:form>

            </section>

            <section class="cafe-danger-zone mt-4">

                <div>
                    <strong>게시판 삭제</strong>

                    <p>
                        삭제한 게시판은 카페 화면에 표시되지 않습니다.
                    </p>
                </div>

                <form method="post"
                      action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/remove"
                      onsubmit="return confirm('정말 이 게시판을 삭제하시겠습니까?');">

                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">

                    <button type="submit"
                            class="btn btn-outline-danger">
                        게시판 삭제
                    </button>

                </form>

            </section>

        </div>
    </div>

</main>

</body>
</html>