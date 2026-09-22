<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title><c:out value="${board.title}"/></title>
	
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

                <!-- 게시글 본문 -->
                <article class="cafe-post-panel">

                    <header class="cafe-post-header">

                        <span class="cafe-post-category">
						    <c:out value="${cafeBoard.boardName}"/>
						</span>

                        <h1 class="cafe-post-title">
                            <c:out value="${board.title}"/>
                        </h1>

                        <div class="cafe-post-meta">

                            <span>
                                작성자
                                <strong>
                                    <c:out value="${board.writer}"/>
                                </strong>
                            </span>

                            <span>
                                등록일 ${fn:replace(fn:substring(board.regDate, 0, 16),'T',' ')}
                            </span>

                            <c:if test="${not empty board.modDate}">
                                <span>
                                    수정일 ${fn:replace(fn:substring(board.modDate, 0, 16),'T',' ')}
                                </span>
                            </c:if>

                            <span>
                                글번호 ${board.bno}
                            </span>

                        </div>
                    </header>

                    <!-- 게시글 내용 -->
                    <div class="cafe-post-content">
                        <c:out value="${board.content}"/>
                    </div>

                    <!-- 첨부파일 -->
                    <c:if test="${not empty attachList}">

                        <section class="cafe-attachment-section">

                            <h2>
                                첨부파일
                            </h2>

                            <div class="cafe-attachment-grid">

                                <c:forEach var="attach"
                                           items="${attachList}">

                                    <div class="cafe-attachment-item">

                                        <c:choose>

                                            <c:when test="${fn:startsWith(
                                                    attach.contentType,
                                                    'image/')}">

                                                <a href="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
                                                   target="_blank">

                                                    <img class="attachment-image"
                                                         src="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
                                                         alt="${fn:escapeXml(attach.fileName)}">

                                                </a>

                                            </c:when>

                                            <c:otherwise>

                                                <div class="cafe-file-placeholder">
                                                    FILE
                                                </div>

                                            </c:otherwise>

                                        </c:choose>

                                        <a class="cafe-attachment-name"
                                           href="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
                                           target="_blank">
                                            <c:out value="${attach.fileName}"/>
                                        </a>

                                    </div>

                                </c:forEach>
                            </div>
                        </section>
                    </c:if>

                    <!-- 게시글 버튼 -->
                    <footer class="cafe-post-actions">

                        <a class="btn btn-outline-secondary"
                           href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post?${fn:escapeXml(pageRequest.link)}">
                            목록
                        </a>

                        <c:if test="${canModify}">

                            <a class="btn cafe-primary-button"
                               href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}/modify?${fn:escapeXml(pageRequest.link)}">
                                수정
                            </a>

                        </c:if>

                    </footer>
                </article>

                <!-- 댓글 영역 -->
                <section class="cafe-reply-panel mt-4">

                    <div class="cafe-reply-heading">
                        <h2>
                            댓글
                        </h2>
                    </div>

                    <c:choose>
                    
						<%-- 댓글 작성 가능 --%>
                        <c:when test="${canWrite}">

                            <form id="replyRegisterForm"
                                  class="cafe-reply-form"
                                  method="post">

                                <label class="form-label"
                                       for="replyInput">
                                    댓글 작성
                                </label>

                                <textarea class="form-control"
                                          id="replyInput"
                                          name="reply"
                                          rows="3"
                                          placeholder="댓글을 입력하세요">${fn:escapeXml(replyInputRegister.reply)}</textarea>

                                <div class="text-end mt-2">

                                    <button class="btn cafe-primary-button"
                                            type="submit">
                                        댓글 등록
                                    </button>

                                </div>
                            </form>
                            
						</c:when>
						
						<%-- 비로그인 --%>
                        <c:when test="${empty pageContext.request.userPrincipal}">

                            <div class="cafe-login-guide">

                                <span>
                                    댓글을 작성하려면 로그인이 필요합니다.
                                </span>

                                <a href="${pageContext.request.contextPath}/member/login?cafeId=${cafeId}&cafeBoardId=${cafeBoard.cafeBoardId}&bno=${board.bno}">
                                    로그인
                                </a>

                            </div>

                        </c:when>
                        
                        <%-- 로그인했지만 카페 등급이 부족함 --%>
                        <c:otherwise>
                        	
                        	<div class="cafe-login-guide">
                        		이 게시판의 댓글 작성 권한이 없습니다.
                        	</div>
                        	
                        </c:otherwise>

                    </c:choose>

                    <c:if test="${not empty registerErrors}">

                        <div class="alert alert-danger mt-3"
                             role="alert">

                            <c:forEach var="error"
                                       items="${registerErrors}">

                                <div>
                                    <c:out value="${error.defaultMessage}" />
                                </div>

                            </c:forEach>
                        </div>
                    </c:if>

                    <div id="replyListArea" class="cafe-reply-list"
                    	data-login-username="${fn:escapeXml(pageContext.request.userPrincipal.name)}">
                    </div>

                </section>

            </section>
        </div>
    </main>

    <!-- 기존 댓글 JavaScript를 이 위치에 그대로 유지 -->
	<script>
 		const contextPath = '${pageContext.request.contextPath}';
 		const bno = '${board.bno}';
 		
 		const csrfHeader = '${_csrf.headerName}';
 		const csrfToken = '${_csrf.token}';
 		
 		const loginUsername = document.querySelector('#replyListArea').dataset.loginUsername;
 		
 		function loadReplies(){
 			fetch(contextPath + '/api/replies?bno=' + bno)
 			.then(response => {
 				if(!response.ok){
 					throw new Error('댓글 조회 실패');
 				}
 				return response.json();
 			})
 			.then(replyList => {
 				console.log(replyList);
 				renderReplies(replyList);
 			})
 			.catch(error => {
 				console.error(error);
 			});
 		}
 		
 		function formatReplyDate(value){
 			if(!value){
 				return '';
 			}
 			
 			if(Array.isArray(value)){
 				const year = value[0];
 				const month = String(value[1]).padStart(2,'0');
 				const day = String(value[2]).padStart(2,'0');
 				const hour = String(value[3] || 0).padStart(2, '0');
 				const minute = String(value[4] || 0).padStart(2, '0');
 				
 				return year + '.' + month + '.' + day + ' ' + hour + ":" + minute;
 			}
 			
 			return String(value).replace('T', ' ').substring(0, 16);
 		}
 		
 		function renderReplies(replyList){
 			const replyListArea = document.querySelector('#replyListArea');
 			
 			replyListArea.innerHTML = '';
 			
 			if(replyList.length == 0){
 				const message = document.createElement('div');
 				message.className =
 		            'reply-empty text-center text-muted';
 				message.textContent = '등록한 댓글이 없습니다';
 				
 				replyListArea.appendChild(message);
 				return;
 			}
 			
 			replyList.forEach(reply => {
 				const replyBox = document.createElement('article');
 				replyBox.className = 'reply-item';
 				
 				const header = document.createElement('div');
 				header.className = 'reply-item-header';
 				
 				// 작성자와 날짜 영역
 				const replyer = document.createElement('strong');
 				replyer.className = 'reply-author';
 				replyer.textContent = reply.replyer;
 				
 				const date = document.createElement('span');
 				date.className = 'reply-date';
 				
 				const dateValue = reply.modDate || reply.regDate;
 				date.textContent = formatReplyDate(dateValue);
 				
 				header.appendChild(replyer);
 				header.appendChild(date);
 				
 				// 댓글 내용
 				const content = document.createElement('div');
 				content.className = 'reply-content';
 				content.textContent = reply.reply;
 				
 				replyBox.appendChild(header);
 				replyBox.appendChild(content);
 				
 				// 자신의 댓글에만 수정,삭제 표시
 				const canWriteReplies = '${canWrite}' === 'true'
 				
 				if(canWriteReplies
 						&& loginUsername !== ''
 						&& loginUsername === reply.replyer){
 					
 					const actions = document.createElement('div');
 					actions.className = 'reply-actions';
 					
 					const modifyDetails = document.createElement('details');
 					modifyDetails.className = 'reply-modify';
 					
 					const modifySummary = document.createElement('summary');
 					modifySummary.className = 'btn btn-sm btn-outline-secondary';
 					modifySummary.textContent = '수정'; 
 					
 					const modifyArea = document.createElement('div');
 					modifyArea.className = 'reply-modify-area';
 					
 					const modifyInput = document.createElement('textarea');
 					modifyInput.className = 'form-control';
 					modifyInput.rows = 3;
 					modifyInput.value = reply.reply;
 					
 					const modifyButton = document.createElement('button');
 					modifyButton.type = 'button';
 					modifyButton.className = 'btn btn-sm cafe-primary-button';
 					modifyButton.textContent = '수정완료';
 					
 					modifyButton.addEventListener(
 	 						'click',
 	 						function(){
 	 							modifyReply(reply.rno, modifyInput);
 	 						}
 	 				);
 					
 					modifyArea.appendChild(modifyInput);
 					modifyArea.appendChild(modifyButton);
 					
 					modifyDetails.appendChild(modifySummary);
 					modifyDetails.appendChild(modifyArea);
 					
 					const deleteButton = document.createElement('button');
 					deleteButton.type = 'button';
 					deleteButton.className = 'btn btn-sm btn-outline-danger';
 					deleteButton.textContent = '삭제';
 					
 					deleteButton.addEventListener(
 	 						'click',
 	 						function(){
 	 							deleteReply(reply.rno);
 	 						}
 	 				);
 					
 					actions.appendChild(modifyDetails);
 					actions.appendChild(deleteButton);
					
 					replyBox.appendChild(actions);
 				}
 				
 				replyListArea.appendChild(replyBox);
 	 		});
 		}
 		
 		function registerReplies(){
 			const replyRegisterForm = 
 				document.querySelector('#replyRegisterForm');
 			
 			if(!replyRegisterForm){
 				return
 			}
 			
			replyRegisterForm.addEventListener(
				'submit',
				function(event){
					event.preventDefault();
					event.stopPropagation();
					
					const replyInput = 
						replyRegisterForm.querySelector(
							'textarea[name="reply"]'		
						);
					
					const replyContent =
						replyInput.value.trim();
					
					if(replyContent === ''){
						alert('댓글 내용을 입력하세요.');
						replyInput.focus();
						return;
					}
					
					fetch(contextPath + '/api/replies', {
						method: 'POST',
						headers: {
							'Content-Type': 'application/json',
							[csrfHeader]: csrfToken
						},
						body: JSON.stringify({
							bno: Number(bno),
							reply: replyContent
						})
					})
					.then(response => {
						if(!response.ok){
							return createApiError(
								response,
								'댓글 등록 실패'
							);
						}
						
						return response.text();
					})
					.then(result => {
						console.log(result);
						replyInput.value = '';
						
						loadReplies();
					})
					.catch(error => {
						console.log(error);
						alert(error.message);
					});
				}
			);
 		}
 		
 		function modifyReply(rno, modifyInput){
 			const replyContent = modifyInput.value.trim();
 			
 			if(replyContent === ''){
 				alert('댓글 내용을 입력하세요.');
 				modifyInput.focus();
 				return;
 			}
 			
 			fetch(
 				contextPath + '/api/replies/' + rno,
 				{
 					method: 'PUT',
 					
 					headers: {
 						'Content-Type': 'application/json',
 						[csrfHeader]: csrfToken
 					},
 					
 					body: JSON.stringify({
 						reply: replyContent
 					})
 				}
 			)
 			.then(response => {
 				if(!response.ok){
 					return createApiError(
						response,
						'댓글 수정 실패'
 					);
 				}
 			})
 			.then(() => {loadReplies();})
 			.catch(error => {
 				console.error(error);
 				alert(error.message);
 			});
 		}
 		
 		function deleteReply(rno){
 			const confirmed = confirm('댓글을 삭제하시겠습니까?');
 			
 			if(!confirmed){
 				return
 			}
 			
 			fetch(
 				contextPath + '/api/replies/' + rno,
 				{
 					method: 'DELETE',
 					
 					headers: {
 						[csrfHeader]: csrfToken
 					}
 				}
 			)
 			.then(response => {
 				if(!response.ok){
 					return createApiError(
 						response,
 						'댓글 삭제 실패'
 					);
 				}	
 			})
 			.then(() => {
 				loadReplies();
 			})
 			.catch(error => {
 				console.error(error);
 				alert(error.message);
 			});
 		}
 		
 		function createApiError(response, defaultMessage){
 			return response.json()
 				.then(errorBody => {
 					let message = errorBody.message;
 					
 					if(errorBody.errors && errorBody.errors.reply){
 						message = errorBody.errors.reply;
 					}
 					
 					throw new Error(message || defaultMessage);
 				});
 		}
 		
	 	loadReplies();
	 	registerReplies();
	</script>
	
</body>
</html>