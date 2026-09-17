<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시판 등록</title>
	
	<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>
<body>

    <jsp:include
        page="/WEB-INF/views/common/header.jsp"/>

    <main class="container main-content py-4">

        <jsp:include
            page="/WEB-INF/views/common/cafeBanner.jsp"/>

        <div class="row g-4 align-items-start">

            <jsp:include
                page="/WEB-INF/views/common/cafeSidebar.jsp"/>

            <section class="col-lg-9">

                <section class="cafe-form-panel">

                    <header class="cafe-form-header">

                        <span class="cafe-form-category">
                            전체글보기
                        </span>

                        <h1>
                            게시글 작성
                        </h1>

                        <p>
                            학습한 내용이나 궁금한 점을 자유롭게 작성해보세요.
                        </p>

                    </header>

                    <form method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/board/register">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <%--
                            @Valid 실행 시 writer 검증을 통과하기 위해 필요하다.
                            Controller에서 실제 로그인 사용자 이름으로 다시 덮어쓴다.
                        --%>
                        <input type="hidden"
                               name="writer"
                               value="${pageContext.request.userPrincipal.name}">

                        <!-- 제목 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="title">
                                제목
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="title"
                                   name="title"
                                   value="${board.title}"
                                   placeholder="제목을 입력하세요">

                        </div>

                        <!-- 내용 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="content">
                                내용
                            </label>

                            <textarea class="form-control cafe-content-input"
                                      id="content"
                                      name="content"
                                      placeholder="내용을 입력하세요">${board.content}</textarea>

                        </div>

                        <!-- 첨부파일 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="uploadFiles">
                                첨부파일
                            </label>

                            <input class="form-control"
                                   type="file"
                                   id="uploadFiles"
                                   name="uploadFiles"
                                   multiple>

                            <div class="form-text">
                                여러 파일을 한 번에 선택할 수 있습니다.
                                파일 하나당 최대 10MB까지 업로드할 수 있습니다.
                            </div>

                        </div>

                        <!-- 검증 오류 -->
                        <c:if test="${not empty errors}">

                            <div class="alert alert-danger"
                                 role="alert">

                                <strong class="d-block mb-2">
                                    입력한 내용을 확인해주세요.
                                </strong>

                                <ul class="mb-0">

                                    <c:forEach var="error"
                                               items="${errors}">

                                        <li>
                                            <c:out value="${error.defaultMessage}"/>
                                        </li>

                                    </c:forEach>
                                </ul>
                            </div>

                        </c:if>

                        <!-- 버튼 -->
                        <div class="cafe-form-actions">

                            <a class="btn btn-outline-secondary"
                               href="${pageContext.request.contextPath}/board/list">
                                취소
                            </a>

                            <button class="btn cafe-primary-button"
                                    type="submit">
                                등록
                            </button>

                        </div>

                    </form>
                </section>
            </section>
        </div>
    </main>

</body>
</html>