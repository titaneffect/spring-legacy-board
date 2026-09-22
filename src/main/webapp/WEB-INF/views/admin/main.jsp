<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"
    prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지</title>

    <jsp:include
        page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

    <jsp:include
        page="/WEB-INF/views/common/header.jsp"/>

    <main class="container main-content py-5">

        <section class="cafe-admin-header">

            <span>
                ADMIN
            </span>

            <h1>
                관리자 페이지
            </h1>

            <p>
                <strong>
                    ${fn:escapeXml(pageContext.request.userPrincipal.name)}
                </strong>
                님으로 로그인했습니다.
            </p>

        </section>

        <div class="row g-4 mt-1">

            <!-- 카페 관리 -->
            <div class="col-md-6">

                <section class="cafe-admin-card">

                    <h2>
                        카페 관리
                    </h2>

                    <p>
                        등록된 카페를 확인할 수 있습니다.
                    </p>

                    <a class="btn cafe-primary-button"
                       href="${pageContext.request.contextPath}/cafe">
                       카페 목록
                    </a>

                </section>
            </div>

            <!-- 회원 관리 -->
            <div class="col-md-6">

                <section class="cafe-admin-card">

                    <h2>
                        회원 관리
                    </h2>

                    <p>
                        회원과 권한 관리 기능은 추후 구현할 예정입니다.
                    </p>

                    <button class="btn btn-outline-secondary"
                            type="button"
                            disabled>
                        준비 중
                    </button>

                </section>
            </div>

            <!-- 카페 관리 -->
            <div class="col-md-6">

                <section class="cafe-admin-card">

                    <h2>
                        카페 설정
                    </h2>

                    <p>
                        카페 이름과 소개 설정 기능은 추후 구현할 예정입니다.
                    </p>

                    <button class="btn btn-outline-secondary"
                            type="button"
                            disabled>
                        준비 중
                    </button>

                </section>
            </div>

            <!-- 시스템 정보 -->
            <div class="col-md-6">

                <section class="cafe-admin-card">

                    <h2>
                        시스템 정보
                    </h2>

                    <p>
                        Spring Legacy와 MyBatis 기반으로 실행 중입니다.
                    </p>

                    <span class="badge text-bg-success">
                        정상
                    </span>

                </section>
            </div>

        </div>
    </main>
</body>
</html>