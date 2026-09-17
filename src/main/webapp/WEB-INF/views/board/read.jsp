<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>${board.title}</title>
	
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
                            전체글보기
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
                                                         alt="${attach.fileName}">

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
                           href="${pageContext.request.contextPath}/board/list?${pageRequest.link}">
                            목록
                        </a>

                        <c:if test="${not empty pageContext.request.userPrincipal
                            and pageContext.request.userPrincipal.name eq board.writer}">

                            <a class="btn cafe-primary-button"
                               href="${pageContext.request.contextPath}/board/modify?bno=${board.bno}&${pageRequest.link}">
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

                        <c:when test="${not empty pageContext.request.userPrincipal}">

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
                                          placeholder="댓글을 입력하세요">${replyInputRegister.reply}</textarea>

                                <div class="text-end mt-2">

                                    <button class="btn cafe-primary-button"
                                            type="submit">
                                        댓글 등록
                                    </button>

                                </div>
                            </form>

                        </c:when>

                        <c:otherwise>

                            <div class="cafe-login-guide">

                                <span>
                                    댓글을 작성하려면 로그인이 필요합니다.
                                </span>

                                <a href="${pageContext.request.contextPath}/member/login?bno=${board.bno}">
                                    로그인
                                </a>

                            </div>

                        </c:otherwise>

                    </c:choose>

                    <c:if test="${not empty registerErrors}">

                        <div class="alert alert-danger mt-3"
                             role="alert">

                            <c:forEach var="error"
                                       items="${registerErrors}">

                                <div>
                                    ${error.defaultMessage}
                                </div>

                            </c:forEach>
                        </div>
                    </c:if>

                    <div id="replyListArea"
                         class="cafe-reply-list">
                    </div>

                </section>

            </section>
        </div>
    </main>

    <!-- 기존 댓글 JavaScript를 이 위치에 그대로 유지 -->
	<h3>댓글</h3>
	<div id="replyListArea"></div>
	
	<script>
 		const contextPath = '${pageContext.request.contextPath}';
 		const bno = '${board.bno}';
 		
 		const csrfHeader = '${_csrf.headerName}';
 		const csrfToken = '${_csrf.token}';
 		
 		const loginUsername = '${pageContext.request.userPrincipal.name}';
 		
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
 		
 		function renderReplies(replyList){
 			const replyListArea = document.querySelector('#replyListArea');
 			
 			replyListArea.innerHTML = '';
 			
 			if(replyList.length == 0){
 				const message = document.createElement('p');
 				message.textContent = '등록한 댓글이 없습니다';
 				
 				replyListArea.appendChild(message);
 				return;
 			}
 			
 			replyList.forEach(reply => {
 				const replyBox = document.createElement('div');
 				replyBox.classList.add('reply-item');
 				
 				const textBox = document.createElement('div');
 				
 				const number = document.createElement('div');
 				number.textContent = reply.rno + '. ';
 				
 				const content = document.createElement('div');
 				content.textContent = reply.reply;
 				
 				const replyer = document.createElement('div');
 				replyer.textContent = '작성자: ' + reply.replyer;
 				
 				const date = document.createElement('div');
 				date.textContent = '수정일: ' + (reply.modDate || reply.regDate || '');
 				
 				textBox.appendChild(number);
 				textBox.appendChild(content);
 				
 				replyBox.appendChild(textBox);
 				replyBox.appendChild(replyer);
 				replyBox.appendChild(date);
 				
 				if(loginUsername !== '' && loginUsername === reply.replyer){
 					
 					const modifyDetails = document.createElement('details');
 					
 					const modifySummary = document.createElement('summary');
 					modifySummary.textContent = '수정'; 
 					
 					const modifyInput = document.createElement('textarea');
 					modifyInput.value = reply.reply;
 					
 					const modifyButton = document.createElement('button');
 					modifyButton.type = 'button';
 					modifyButton.textContent = '수정완료';
 					
 					const deleteButton = document.createElement('button');
 					deleteButton.type = 'button';
 					deleteButton.textContent = '삭제';
					
 					modifyButton.addEventListener(
 						'click',
 						function(){
 							modifyReply(reply.rno, modifyInput);
 						}
 					);
 					
 					deleteButton.addEventListener(
 						'click',
 						function(){
 							deleteReply(reply.rno);
 						}
 					)
 					
 					modifyDetails.appendChild(modifySummary);
 					modifyDetails.appendChild(modifyInput);
 					modifyDetails.appendChild(modifyButton);
 					replyBox.appendChild(modifyDetails);
 					
 					replyBox.appendChild(deleteButton);
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