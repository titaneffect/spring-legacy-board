<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>${board.title}</title>
	<style>
		.reply-item{
			margin-bottom: 20px;
		}
	</style>
</head>
<body>
    <c:if test="${empty pageContext.request.userPrincipal}">
		<a href="${pageContext.request.contextPath}/member/login?bno=${board.bno}">
			로그인
		</a>
		<a href="${pageContext.request.contextPath}/member/register">
			회원가입
		</a>
	</c:if>
	<c:if test="${not empty pageContext.request.userPrincipal}">
        <span>
            ${pageContext.request.userPrincipal.name}
        </span>

        <form method="post"
              action="${pageContext.request.contextPath}/logout">

            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">

            <button type="submit">로그아웃</button>
        </form>
    </c:if>

	<h1>${board.title}</h1>
	
	<p>번호: ${board.bno}</p>
	<p>작성자: ${board.writer}</p>
	<p>내용: ${board.content}</p>
	
	<a href="${pageContext.request.contextPath}/board/list?&${pageRequest.link}">
		목록
	</a>
	<c:if test="${not empty pageContext.request.userPrincipal and pageContext.request.userPrincipal.name eq board.writer}">
		<a href="${pageContext.request.contextPath}/board/modify?bno=${board.bno}&${pageRequest.link}">
			수정
		</a>
	</c:if>

	<c:choose>
		<c:when test="${not empty pageContext.request.userPrincipal}">
			<form id="replyRegisterForm" method="post" action="${pageContext.request.contextPath}/reply/register">
				<textarea name="reply">${replyInputRegister.reply}</textarea>
				<button type="submit">댓글 등록</button>
			</form>
		</c:when>
		
		<c:otherwise>
			<p>댓글을 작성하려면 로그인이 필요합니다.</p>
		</c:otherwise>
	</c:choose>
	
	
	<c:if test="${not empty registerErrors}">
		<c:forEach var="error" items="${registerErrors}">
			<li>${error.defaultMessage}</li>
		</c:forEach>
	</c:if>
	
	<h3>첨부파일</h3>
	<c:if test="${not empty attachList}">
		<c:forEach var="attach" items="${attachList}">
			<div>
				${attach.fileName}
				<c:if test="${fn:startsWith(attach.contentType, 'image/')}">
					<img src="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
					alt="${attach.fileName}"
					width="150">
				</c:if>
			</div>
		</c:forEach>
	</c:if>
	
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