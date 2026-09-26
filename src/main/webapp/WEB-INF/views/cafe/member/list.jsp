<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>카페 회원 관리</title>

<jsp:include page="/WEB-INF/views/common/styles.jsp" />
</head>

<body>

	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<main class="container py-5">

		<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
		    <div>
		        <div class="small text-success fw-semibold">CAFE MEMBER</div>
		        <h1 class="h3 mb-1">
		            <c:out value="${cafe.cafeName}"/> 회원 관리
		        </h1>
		    </div>
		
		    <div class="d-flex flex-wrap align-items-center gap-2">
		        <button type="button"
		                class="btn btn-outline-success member-filter-button active"
		                data-filter="ACTIVE" aria-pressed="true">카페 회원</button>
		
		        <button type="button"
		                class="btn btn-outline-success member-filter-button"
		                data-filter="APPLICATIONS" aria-pressed="false">가입 신청
		                <span id="pendingCountBadge"
          					class="badge rounded-pill text-bg-danger ms-1 d-none"></span>
		        </button>
		
		        <button type="button"
		                class="btn btn-outline-success member-filter-button"
		                data-filter="WITHDRAWN" aria-pressed="false">탈퇴 회원</button>
		
		        <button type="button"
		                class="btn btn-outline-success member-filter-button"
		                data-filter="BANNED" aria-pressed="false">강퇴 회원</button>
		
		        <a class="btn btn-outline-secondary"
		           href="${pageContext.request.contextPath}/cafe/${cafe.cafeId}">
		            카페로 돌아가기
		        </a>
		    </div>
		</div>

		<section class="border rounded-3 bg-white p-4">

			<c:choose>

				<c:when test="${empty memberList}">
					<div class="text-center text-muted py-5">가입한 회원이 없습니다.</div>
				</c:when>

				<c:otherwise>

					<div class="table-responsive">

						<table class="table align-middle cafe-member-table">
							
							<colgroup>
						        <col style="width: 20%;"> <%-- 사용자 --%>
						        <col style="width: 14%;"> <%-- 카페 역할 --%>
						        <col style="width: 14%;"> <%-- 가입 상태 --%>
						        <col style="width: 20%;"> <%-- 가입일 --%>
						        <col style="width: 32%;"> <%-- 회원 관리 --%>
						    </colgroup>

							<thead>
								<tr>
									<th>사용자</th>
									<th>카페 역할</th>
									<th>가입 상태</th>
									<th>가입일</th>
									<th class="text-end">회원 관리</th>
								</tr>
							</thead>

							<tbody>

								<c:forEach var="member" items="${memberList}">

									<tr data-status="${member.status}">

										<td><strong> <c:out
													value="${member.memberUsername}" />
										</strong></td>

										<td><c:choose>
										
												<c:when test="${member.status ne 'ACTIVE'}">
												    <span class="badge text-bg-light text-secondary border">
												        카페 비회원
												    </span>
												</c:when>

												<c:when test="${member.cafeRole eq 'OWNER'}">
													<span class="badge cafe-member-owner-badge"> 소유자 </span>
												</c:when>

												<c:when test="${member.cafeRole eq 'MANAGER'}">
													<span class="badge text-bg-primary"> 운영자 </span>
												</c:when>

												<c:otherwise>
													<span class="badge text-bg-secondary"> 일반 회원 </span>
												</c:otherwise>

											</c:choose></td>

										<td>
										    <c:choose>
										        <c:when test="${member.status eq 'ACTIVE'}">
										            <span class="badge rounded-pill text-bg-success">활동 중</span>
										        </c:when>
										        <c:when test="${member.status eq 'PENDING'}">
										            <span class="badge rounded-pill text-bg-warning">승인 대기</span>
										        </c:when>
										        <c:when test="${member.status eq 'REJECTED'}">
										            <span class="badge rounded-pill text-bg-secondary">가입 거절</span>
										        </c:when>
										        <c:when test="${member.status eq 'WITHDRAWN'}">
										            <span class="badge rounded-pill text-bg-light text-secondary border">탈퇴</span>
										        </c:when>
										        <c:when test="${member.status eq 'BANNED'}">
										            <span class="badge rounded-pill text-bg-danger">강퇴</span>
										        </c:when>
										        <c:otherwise>
										            <c:out value="${member.status}"/>
										        </c:otherwise>
										    </c:choose>
										</td>

										<td class="text-nowrap"><c:choose>
												<c:when test="${empty member.joinedAt}">
													<span class="text-muted">—</span>
												</c:when>
												<c:otherwise>
													<span class="small fw-medium"> <c:out
															value="${member.joinedAtDisplay}" />
													</span>
												</c:otherwise>
											</c:choose></td>

										<td class="text-end"><c:choose>

												<%-- OWNER는 역할 변경 불가 --%>
												<c:when test="${member.cafeRole eq 'OWNER'}">

													<span class="small text-muted"> 변경 불가 </span>

												</c:when>

												<c:when test="${member.status eq 'PENDING'}">
													<div class="d-flex justify-content-end gap-2">
														<form method="post"
															action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/approve">
															<input type="hidden" name="${_csrf.parameterName}"
																value="${_csrf.token}"> <input type="hidden"
																name="memberUsername"
																value="${fn:escapeXml(member.memberUsername)}">
															<button type="submit" class="btn btn-sm btn-success">
																승인</button>
														</form>

														<form method="post"
															action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/reject"
															onsubmit="return confirm('이 가입 신청을 거절하시겠습니까?');">
															<input type="hidden" name="${_csrf.parameterName}"
																value="${_csrf.token}"> <input type="hidden"
																name="memberUsername"
																value="${fn:escapeXml(member.memberUsername)}">
															<button type="submit"
																class="btn btn-sm btn-outline-danger">거절</button>
														</form>
													</div>
												</c:when>

												<%-- 강퇴된 회원 --%>
												<c:when test="${member.status eq 'BANNED'}">
													<form method="post" class="m-0"
														action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/${fn:escapeXml(member.memberUsername)}/unban"
														onsubmit="return confirm('이 회원의 강퇴를 해제하시겠습니까?');">

														<input type="hidden" name="${_csrf.parameterName}"
															value="${_csrf.token}">

														<button type="submit"
															class="btn btn-sm btn-outline-primary">강퇴 해제</button>
													</form>
												</c:when>

												<%-- 현재 활동 중인 회원 --%>
												<c:when test="${member.status eq 'ACTIVE'}">

													<div
														class="d-flex justify-content-end align-items-center gap-2">

														<form method="post"
															action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/${fn:escapeXml(member.memberUsername)}/role"
															class="d-flex justify-content-end
									                             align-items-center gap-2">

															<input type="hidden" name="${_csrf.parameterName}"
																value="${_csrf.token}"> <select name="cafeRole"
																class="form-select form-select-sm" style="width: 130px;">

																<option value="MEMBER"
																	${member.cafeRole eq 'MEMBER'
									                                ? 'selected' : ''}>
																	일반 회원</option>

																<option value="MANAGER"
																	${member.cafeRole eq 'MANAGER'
									                                ? 'selected' : ''}>
																	운영자</option>

															</select>

															<button type="submit"
																class="btn btn-sm btn-outline-success">변경</button>

														</form>

														<form method="post" class="m-0"
															action="${pageContext.request.contextPath}/cafe/${cafe.cafeId}/member/${fn:escapeXml(member.memberUsername)}/ban"
															onsubmit="return confirm('이 회원을 강퇴하시겠습니까?\n강퇴된 회원은 다시 가입할 수 없습니다.');">

															<input type="hidden" name="${_csrf.parameterName}"
																value="${_csrf.token}">

															<button type="submit"
																class="btn btn-sm btn-outline-danger">강퇴</button>
														</form>

													</div>

												</c:when>

												<%-- 가입 거절 또는 탈퇴한 회원 --%>
												<c:otherwise>
													<span class="small text-muted"> 관리 작업 없음 </span>
												</c:otherwise>

											</c:choose></td>
									</tr>

								</c:forEach>

							</tbody>

						</table>
						
						<div id="memberFilterEmpty"
						     class="text-center text-muted py-4 d-none">
						    표시할 회원이 없습니다.
						</div>

					</div>

				</c:otherwise>

			</c:choose>

		</section>

	</main>

	<script>
	    const filterButtons =
	        document.querySelectorAll('.member-filter-button');
	    const memberRows =
	        document.querySelectorAll('tr[data-status]');
	    const emptyMessage =
	        document.getElementById('memberFilterEmpty');
	    
	    const emptyMessages = {
	    	    ACTIVE: '활동 중인 카페 회원이 없습니다.',
	    	    APPLICATIONS: '가입 신청 내역이 없습니다.',
	    	    WITHDRAWN: '탈퇴한 회원이 없습니다.',
	    	    BANNED: '강퇴된 회원이 없습니다.'
	    	};
	
	    function showMemberFilter(filter) {
	        let visibleCount = 0;
	
	        memberRows.forEach(row => {
	            const status = row.dataset.status;
	            const visible = filter === 'APPLICATIONS'
	                ? status === 'PENDING' || status === 'REJECTED'
	                : status === filter;
	
	            row.style.display = visible ? '' : 'none';
	            if (visible) visibleCount++;
	        });
	
	        filterButtons.forEach(button => {
	            const selected = button.dataset.filter === filter;
	            button.classList.toggle('active', selected);
	            button.setAttribute('aria-pressed', String(selected));
	        });
	
	        if (emptyMessage) {
	            emptyMessage.textContent =
	                emptyMessages[filter] || '표시할 회원이 없습니다.';
	            emptyMessage.classList.toggle('d-none', visibleCount > 0);
	        }
	    }
	
	    filterButtons.forEach(button => {
	        button.addEventListener('click', () => {
	            showMemberFilter(button.dataset.filter);
	        });
	    });
	    
	    const pendingCount =
	        Array.from(memberRows)
	            .filter(row => row.dataset.status === 'PENDING')
	            .length;

	    const pendingCountBadge =
	        document.getElementById('pendingCountBadge');

	    if (pendingCount > 0) {
	        pendingCountBadge.textContent = pendingCount;
	        pendingCountBadge.classList.remove('d-none');
	    }
	
	    showMemberFilter('ACTIVE');
	</script>

</body>
</html>