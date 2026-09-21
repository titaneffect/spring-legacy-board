<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:out value="${cafe.cafeName}"/></title>

<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/header.jsp"/>

<main class="container py-5">

	<nav class="cafe-breadcrumb"
	     aria-label="카페 경로">
	
	    <a href="${pageContext.request.contextPath}/cafe">
	        카페 홈
	    </a>
	
	    <span aria-hidden="true">
	        &rsaquo;
	    </span>
	
	    <strong>
	        <c:out value="${cafe.cafeName}"/>
	    </strong>
	
	</nav>

    <section class="border rounded-3 bg-white p-5 mb-4">
		
		<div>
	        <div class="small text-success fw-semibold mb-2">
	            CAFE
	        </div>
	
	        <h1 class="display-6 fw-bold mb-3">
	            <c:out value="${cafe.cafeName}"/>
	        </h1>
		</div>
        
        <p class="lead text-muted mb-4">
            <c:choose>
                <c:when test="${not empty cafe.description}">
                    <c:out value="${cafe.description}"/>
                </c:when>

                <c:otherwise>
                    등록된 카페 소개가 없습니다.
                </c:otherwise>
            </c:choose>
        </p>

        <div class="d-flex gap-3 align-items-center">
            <span class="badge text-bg-success">
                <c:out value="${cafe.status}"/>
            </span>

            <span class="text-muted">
                운영자:
                <strong>
                    <c:out value="${cafe.ownerUsername}"/>
                </strong>
            </span>
        </div>

    </section>

    <div class="row g-4">

        <div class="col-lg-8">
            <section class="cafe-board-panel">

                <div class="d-flex
            justify-content-between
            align-items-center
            gap-3">
	
				    <div class="cafe-board-title">
					        카페 게시판
				    </div>
				
				    <c:if test="${not empty pageContext.request.userPrincipal
				                  and pageContext.request.userPrincipal.name
				                      eq cafe.ownerUsername}">
				
				        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/register"
				           class="btn btn-sm cafe-primary-button">
				            게시판 만들기
				        </a>
				
				    </c:if>
				
				</div>
				
				<c:choose>
				
				    <c:when test="${empty cafeBoardList}">
				        <div class="text-center text-muted py-5">
				            아직 만들어진 게시판이 없습니다.
				        </div>
				    </c:when>
				
				    <c:otherwise>
				
				        <div class="list-group list-group-flush mt-3">
				
				            <c:forEach var="cafeBoard"
				                       items="${cafeBoardList}">
				
				                <div class="list-group-item px-0 py-3">
				
				                    <div class="d-flex
				                                justify-content-between
				                                align-items-center
				                                gap-3">
				
				                        <div>
				                        	<a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/post">
					                            <strong class="d-block mb-1">
					                                <c:out value="${cafeBoard.boardName}"/>
					                            </strong>
											</a>
				                            <span class="small text-muted">
				                                읽기:
				                                <c:out value="${cafeBoard.readRole}"/>
				
				                                · 쓰기:
				                                <c:out value="${cafeBoard.writeRole}"/>
				                            </span>
				                        </div>
				
				                        <div class="d-flex
										            align-items-center
										            flex-wrap
										            gap-2">
										
										    <c:choose>
										
										        <c:when test="${cafeBoard.boardType eq 'NOTICE'}">
										            <span class="badge text-bg-success">
										                공지
										            </span>
										        </c:when>
										
										        <c:otherwise>
										            <span class="badge text-bg-light">
										                일반
										            </span>
										        </c:otherwise>
										
										    </c:choose>
										
										    <c:if test="${not empty pageContext.request.userPrincipal
										                  and pageContext.request.userPrincipal.name
										                      eq cafe.ownerUsername}">
										
										        <a href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/board/${cafeBoard.cafeBoardId}/modify"
										           class="btn btn-sm btn-outline-secondary">
										            관리
										        </a>
										
										    </c:if>
										
										</div>
				
				                    </div>
				                </div>
				
				            </c:forEach>
				
				        </div>
				
				    </c:otherwise>
				
				</c:choose>

            </section>
            
        </div>

        <div class="col-lg-4">

		    <section class="cafe-info-card">
		
		        <header class="cafe-info-header">
		            <span class="cafe-info-eyebrow">
		                CAFE INFO
		            </span>
		
		            <h2>카페 정보</h2>
		        </header>
		
		        <div class="cafe-info-list">
		
		            <div class="cafe-info-row">
		                <span class="cafe-info-label">
		                    카페 번호
		                </span>
		
		                <strong class="cafe-info-value">
		                    #<c:out value="${cafe.cafeId}"/>
		                </strong>
		            </div>
		
		            <div class="cafe-info-row">
		                <span class="cafe-info-label">
		                    운영자
		                </span>
		
		                <strong class="cafe-info-value">
		                    <c:out value="${cafe.ownerUsername}"/>
		                </strong>
		            </div>
		
		        </div>
		        
		        <div class="cafe-membership-area">
		       
				    <div class="cafe-membership-title">
				        <span class="cafe-membership-title-dot"></span>
				        나의 카페 활동
				    </div>
				
				    <c:choose>
			
				        <%-- 비로그인 사용자 --%>
				        <c:when test="${empty pageContext.request.userPrincipal}">
				
				            <c:url var="cafeLoginUrl"
							       value="/member/login">
							
							    <c:param name="returnUrl"
							             value="${pageContext.request.contextPath}/cafe/${cafe.cafeId}"/>
							
							</c:url>
							
							<a class="btn cafe-primary-button w-100"
							   href="${cafeLoginUrl}">
							    로그인 후 카페 가입
							</a>
				
				        </c:when>
				
				        <%-- 로그인했지만 아직 가입하지 않은 사용자 --%>
				        <c:when test="${empty currentCafeMember}">
				
				            <form method="post"
				                  action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/join">
				
				                <input type="hidden"
				                       name="${_csrf.parameterName}"
				                       value="${_csrf.token}">
				
				                <button type="submit"
				                        class="btn cafe-primary-button w-100">
				                    카페 가입
				                </button>
				
				            </form>
				
				        </c:when>
				
				        <%-- 이미 가입한 사용자 --%>
				        <c:otherwise>
	
						    <div class="cafe-membership-card">
						
						        <div class="cafe-membership-summary">
						
						            <span class="cafe-membership-dot"></span>
						
						            <div class="cafe-membership-text">
						
						                <span class="cafe-membership-label">
						                    카페 회원
						                </span>
						
						                <strong class="cafe-membership-role">
						                    <c:choose>
						
						                        <c:when test="${currentCafeMember.cafeRole eq 'OWNER'}">
						                            소유자
						                        </c:when>
						
						                        <c:when test="${currentCafeMember.cafeRole eq 'MANAGER'}">
						                            운영자
						                        </c:when>
						
						                        <c:otherwise>
						                            일반 회원
						                        </c:otherwise>
						
						                    </c:choose>
						                </strong>
						
						            </div>
						
						        </div>
						
						        <c:if test="${currentCafeMember.cafeRole ne 'OWNER'}">
						
						            <form method="post"
						                  action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/withdraw"
						                  class="cafe-withdraw-form"
						                  onsubmit="return confirm('정말 이 카페에서 탈퇴하시겠습니까?');">
						
						                <input type="hidden"
						                       name="${_csrf.parameterName}"
						                       value="${_csrf.token}">
						
						                <button type="submit"
						                        class="cafe-withdraw-button">
						                    카페 탈퇴
						                </button>
						
						            </form>
						
						        </c:if>
						
						    </div>
						
						</c:otherwise>
				
				    </c:choose>
				
				</div>
		
		        <c:if test="${not empty pageContext.request.userPrincipal
		                      and pageContext.request.userPrincipal.name
		                          eq cafe.ownerUsername}">
		
		            <div class="cafe-admin-section">
		
		                <div class="cafe-admin-title">
		                    <span class="cafe-admin-dot"></span>
		                    운영 관리
		                </div>
		
		                <nav class="cafe-admin-menu">
		
		                    <a class="cafe-admin-link"
		                       href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member">
		
		                        <span>
		                            <strong>회원 관리</strong>
		
		                            <small>
		                                가입 회원과 역할을 관리합니다.
		                            </small>
		                        </span>
		
		                        <span class="cafe-admin-arrow"
		                              aria-hidden="true">
		                            &rsaquo;
		                        </span>
		
		                    </a>
		
		                    <a class="cafe-admin-link"
		                       href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/modify">
		
		                        <span>
		                            <strong>카페 정보 수정</strong>
		
		                            <small>
		                                이름과 소개 정보를 수정합니다.
		                            </small>
		                        </span>
		
		                        <span class="cafe-admin-arrow"
		                              aria-hidden="true">
		                            &rsaquo;
		                        </span>
		
		                    </a>
		
		                </nav>
		
		            </div>
		
		        </c:if>
		
		    </section>
		
		</div>
	</div>

</main>

</body>
</html>