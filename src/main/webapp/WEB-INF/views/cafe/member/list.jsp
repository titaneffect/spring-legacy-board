<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>카페 회원 관리</title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

    <div class="d-flex justify-content-between
                align-items-center mb-4">

        <div>
            <div class="small text-success fw-semibold">
                CAFE MEMBER
            </div>

            <h1 class="h3 mb-1">
                <c:out value="${cafe.cafeName}"/>
                회원 관리
            </h1>
        </div>

        <a class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}">
            카페로 돌아가기
        </a>

    </div>

    <section class="border rounded-3 bg-white p-4">

        <c:choose>

            <c:when test="${empty memberList}">
                <div class="text-center text-muted py-5">
                    가입한 회원이 없습니다.
                </div>
            </c:when>

            <c:otherwise>

                <div class="table-responsive">

                    <table class="table align-middle">

                        <thead>
                            <tr>
                                <th>사용자</th>
                                <th>카페 역할</th>
                                <th>가입 상태</th>
                                <th>가입일</th>
                                <th class="text-end">역할 관리</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="member"
                                       items="${memberList}">

                                <tr>
                                    <td>
                                    	<strong>
                                        	<c:out value="${member.memberUsername}"/>
                                        </strong>
                                    </td>

									<td>
								        <c:choose>
								
								            <c:when test="${member.cafeRole eq 'OWNER'}">
								                <span class="badge text-bg-success">
								                    소유자
								                </span>
								            </c:when>
								
								            <c:when test="${member.cafeRole eq 'MANAGER'}">
								                <span class="badge text-bg-primary">
								                    운영자
								                </span>
								            </c:when>
								
								            <c:otherwise>
								                <span class="badge text-bg-secondary">
								                    일반 회원
								                </span>
								            </c:otherwise>
								
								        </c:choose>
								    </td>

                                    <td>
                                        <c:out value="${member.status}"/>
                                    </td>

                                    <td>
                                        <c:out value="${member.joinedAt}"/>
                                    </td>
                                    
                                    <td class="text-end">

								        <c:choose>
								
								            <%-- OWNER는 역할 변경 불가 --%>
								            <c:when test="${member.cafeRole eq 'OWNER'}">
								
								                <span class="small text-muted">
								                    변경 불가
								                </span>
								
								            </c:when>
								
								            <c:otherwise>
								
								                <form method="post"
								                      action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/${member.memberUsername}/role"
								                      class="d-flex justify-content-end
								                             align-items-center gap-2">
								
								                    <input type="hidden"
								                           name="${_csrf.parameterName}"
								                           value="${_csrf.token}">
								
								                    <select name="cafeRole"
								                            class="form-select form-select-sm"
								                            style="width: 130px;">
								
								                        <option value="MEMBER"
								                            ${member.cafeRole eq 'MEMBER'
								                                ? 'selected' : ''}>
								                            일반 회원
								                        </option>
								
								                        <option value="MANAGER"
								                            ${member.cafeRole eq 'MANAGER'
								                                ? 'selected' : ''}>
								                            운영자
								                        </option>
								
								                    </select>
								
								                    <button type="submit"
								                            class="btn btn-sm btn-outline-success">
								                        변경
								                    </button>
								
								                </form>
								
								            </c:otherwise>
								
								        </c:choose>
								
								    </td>
                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </div>

            </c:otherwise>

        </c:choose>

    </section>

</main>

</body>
</html>