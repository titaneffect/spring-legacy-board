<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${exceptionName}</title>
</head>
<body>

    <p>${message}</p>

    <a href="${pageContext.request.contextPath}/board/list">
        목록으로 돌아가기
    </a>
</body>
</html>