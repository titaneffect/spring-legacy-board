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
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="member"
                                       items="${memberList}">

                                <tr>
                                    <td>
                                        <c:out value="${member.memberUsername}"/>
                                    </td>

                                    <td>
                                        <c:out value="${member.cafeRole}"/>
                                    </td>

                                    <td>
                                        <c:out value="${member.status}"/>
                                    </td>

                                    <td>
                                        <c:out value="${member.joinedAt}"/>
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