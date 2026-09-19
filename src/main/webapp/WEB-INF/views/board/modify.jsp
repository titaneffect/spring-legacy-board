<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title><c:out value="${board.title}"/> 수정</title>
	
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
                            게시글 수정
                        </h1>

                        <p>
                            게시글 내용과 첨부파일을 수정할 수 있습니다.
                        </p>

                    </header>

                    <form id="modifyForm"
                          method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}/modify">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <input type="hidden"
                               name="bno"
                               value="${board.bno}">

                        <input type="hidden"
                               name="page"
                               value="${pageRequest.page}">

                        <input type="hidden"
                               name="size"
                               value="${pageRequest.size}">

                        <input type="hidden"
                               name="type"
                               value="${pageRequest.type}">

                        <input type="hidden"
                               name="keyword"
                               value="${pageRequest.keyword}">

                        <input type="hidden"
                               name="writer"
                               value="${board.writer}">

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
                                   value="${fn:escapeXml(board.title)}">

                        </div>

                        <!-- 내용 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="content">
                                내용
                            </label>

                            <textarea class="form-control cafe-content-input"
                                      id="content"
                                      name="content"><c:out value="${board.content}"/></textarea>

                        </div>

                        <!-- 기존 첨부파일 -->
                        <c:if test="${not empty attachList}">

                            <section class="cafe-existing-attachments mb-4">

                                <h2>
                                    기존 첨부파일
                                </h2>

                                <p>
                                    삭제할 파일의 X 버튼을 누른 후
                                    수정 버튼을 눌러주세요.
                                </p>

                                <div class="cafe-existing-attachment-grid">

                                    <c:forEach var="attach"
                                               items="${attachList}">

                                        <div class="existing-attach cafe-existing-attachment"
                                             data-ano="${attach.ano}">

                                            <c:choose>

                                                <c:when test="${fn:startsWith(
                                                        attach.contentType,
                                                        'image/')}">

                                                    <img src="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
                                                         alt="${attach.fileName}">

                                                </c:when>

                                                <c:otherwise>

                                                    <div class="cafe-file-placeholder">
                                                        FILE
                                                    </div>

                                                </c:otherwise>

                                            </c:choose>

                                            <span class="cafe-existing-file-name">
                                                <c:out value="${attach.fileName}"/>
                                            </span>

                                            <button class="attach-remove-button"
                                                    type="button"
                                                    aria-label="${attach.fileName} 삭제">
                                                ×
                                            </button>

                                        </div>

                                    </c:forEach>
                                </div>
                            </section>
                        </c:if>

                        <!-- 새 첨부파일 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="uploadFiles">
                                새 첨부파일
                            </label>

                            <input class="form-control"
                                   type="file"
                                   id="uploadFiles"
                                   name="uploadFiles"
                                   multiple>

                            <div class="form-text">
                                기존 파일은 유지되고 선택한 파일이 추가됩니다.
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

                        <!-- 수정 버튼 -->
                        <div class="cafe-form-actions">

                            <a class="btn btn-outline-secondary"
                               href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}?${pageRequest.link}">
                                취소
                            </a>

                            <button class="btn cafe-primary-button"
                                    type="submit">
                                수정 완료
                            </button>

                        </div>
                    </form>
                </section>

                <!-- 게시글 삭제 -->
                <section class="cafe-danger-zone mt-4">

                    <div>
                        <strong>
                            게시글 삭제
                        </strong>

                        <p>
                            게시글과 댓글, 첨부파일이 모두 삭제됩니다.
                        </p>
                    </div>

                    <form method="post"
                          action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}/remove"
                          onsubmit="return confirm('게시글을 삭제하시겠습니까?');">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <input type="hidden"
                               name="bno"
                               value="${board.bno}">

                        <button class="btn btn-outline-danger"
                                type="submit">
                            게시글 삭제
                        </button>

                    </form>
                </section>

            </section>
        </div>
    </main>

    <!-- 기존 첨부파일 삭제 예약 JavaScript -->

    <script>
        const modifyForm =
            document.querySelector('#modifyForm');

        const removeButtons =
            document.querySelectorAll(
                '.attach-remove-button'
            );

        removeButtons.forEach(button => {

            button.addEventListener(
                'click',
                function () {

                    const attachItem =
                        button.closest(
                            '.existing-attach'
                        );

                    const ano =
                        attachItem.dataset.ano;

                    const hiddenInput =
                        document.createElement('input');

                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'deleteAnoList';
                    hiddenInput.value = ano;

                    modifyForm.appendChild(hiddenInput);

                    attachItem.style.display = 'none';
                }
            );
        });
    </script>

</body>
</html>