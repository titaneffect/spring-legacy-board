<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://www.springframework.org/tags/form"
    prefix="form"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카페 정보 수정</title>

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
                            카페 관리
                        </div>

                        <h1 class="h3 mb-2">
                            카페 정보 수정
                        </h1>

                        <p class="text-muted mb-0">
                            카페 이름과 소개를 수정할 수 있습니다.
                        </p>
                    </div>
                </div>

                <form:form
                    method="post"
                    modelAttribute="cafe"
                    action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/modify">

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
                            placeholder="카페 소개를 입력하세요"/>

                        <form:errors
                            path="description"
                            cssClass="text-danger small d-block mt-2"/>
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
                
                <c:if test="${not empty pageContext.request.userPrincipal
				              and pageContext.request.userPrincipal.name
				                  eq cafe.ownerUsername}">
				
				    <section class="cafe-danger-zone">
				
				        <div class="cafe-danger-content">
				
				            <div>
				                <h2>카페 삭제</h2>
				
				                <p>
				                    카페를 삭제하면 더 이상 일반 사용자에게
				                    표시되지 않습니다.
				                </p>
				            </div>
				
				            <form method="post"
				                  action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/remove"
				                  onsubmit="return confirm('정말 이 카페를 삭제하시겠습니까?');">
				
				                <input type="hidden"
				                       name="${_csrf.parameterName}"
				                       value="${_csrf.token}">
				
				                <button type="submit"
				                        class="btn btn-outline-danger cafe-danger-button">
				                    카페 삭제
				                </button>
				
				            </form>
				
				        </div>
				
				    </section>
				
				</c:if>

            </section>

        </div>
    </div>

</main>

</body>
</html>