<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시판 등록</title>
	
	<jsp:include page="/WEB-INF/views/common/styles.jsp"/>
	
	<script src="https://cdn.tiny.cloud/1/qfb3wzju9uwoeoo1z3yvi05amppbej4jv3phc7r1v8xzstov/tinymce/8/tinymce.min.js"
        referrerpolicy="origin"
        crossorigin="anonymous">
	</script>
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

                <section class="cafe-form-panel">

                    <header class="cafe-form-header">

                        <span class="cafe-form-category">
						    <c:out value="${cafeBoard.boardName}"/>
						</span>

                        <h1>
                            게시글 작성
                        </h1>

                        <p>
                            학습한 내용이나 궁금한 점을 자유롭게 작성해보세요.
                        </p>

                    </header>

                    <form id="boardRegisterForm"
                    	  method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/register">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                               
                        <input type="hidden"
                        	   name="cafeId"
                        	   value="${cafeId}">
                        	   
                        <input type="hidden"
                        	   name="cafeBoardId"
                        	   value="${cafeBoard.cafeBoardId}">

                        <%--
                            @Valid 실행 시 writer 검증을 통과하기 위해 필요하다.
                            Controller에서 실제 로그인 사용자 이름으로 다시 덮어쓴다.
                        --%>
                        <input type="hidden"
                               name="writer"
                               value="${fn:escapeXml(pageContext.request.userPrincipal.name)}">

                        <!-- 제목 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="title">
                                제목
                            </label>

                            <input class="form-control"
                                   type="text"
                                   id="title"
                                   name="title"
                                   value="${fn:escapeXml(board.title)}"
                                   placeholder="제목을 입력하세요">

                        </div>

                        <!-- 내용 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="content">
                                내용
                            </label>

                            <textarea class="form-control cafe-content-input"
                                      id="content"
                                      name="content"
                                      placeholder="내용을 입력하세요"><c:out value="${board.content}"/></textarea>

                        </div>

                        <!-- 첨부파일 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="uploadFiles">
                                첨부파일
                            </label>

                            <input class="form-control"
                                   type="file"
                                   id="uploadFiles"
                                   name="uploadFiles"
                                   multiple>

                            <div class="form-text">
                                여러 파일을 한 번에 선택할 수 있습니다.
                                파일 하나당 최대 10MB까지 업로드할 수 있습니다.
                            </div>

                        </div>
                        
                        <!-- TinyMCE 본문 이미지 파일 보관 영역 -->
						<div id="contentImageInputs"></div>

                        <!-- 검증 오류 -->
                        <c:if test="${not empty errors}">

                            <div class="alert alert-danger"
                                 role="alert">

                                <strong class="d-block mb-2">
                                    입력한 내용을 확인해주세요.
                                </strong>

                                <ul class="mb-0">

                                    <c:forEach var="error"
                                               items="${errors}">

                                        <li>
                                            <c:out value="${error.defaultMessage}"/>
                                        </li>

                                    </c:forEach>
                                </ul>
                            </div>

                        </c:if>

                        <!-- 버튼 -->
                        <div class="cafe-form-actions">

                            <a class="btn btn-outline-secondary"
                               href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post">
                                취소
                            </a>

                            <button class="btn cafe-primary-button"
                                    type="submit">
                                등록
                            </button>

                        </div>

                    </form>
                </section>
            </section>
        </div>
    </main>

<script>
    let contentImageSequence = 0;

    tinymce.init({
        selector: '#content',

        plugins: 'lists link table media image',

        toolbar: 'undo redo | blocks fontfamily fontsize | '
                + 'bold italic underline | '
                + 'alignleft aligncenter alignright | '
                + 'bullist numlist | table link media contentImage',
                
        formats: {
            alignleft: {
                selector: 'p,h1,h2,h3,h4,h5,h6',
                styles: {
                    textAlign: 'left'
                }
            },

            aligncenter: {
                selector: 'p,h1,h2,h3,h4,h5,h6',
                styles: {
                    textAlign: 'center'
                }
            },

            alignright: {
                selector: 'p,h1,h2,h3,h4,h5,h6',
                styles: {
                    textAlign: 'right'
                }
            }
        },

        menubar: false,

        // 브라우저 미리보기 주소를 TinyMCE가 임의로 변환하지 않게 한다.
        convert_urls: false,

        object_resizing: 'img',
        resize_img_proportional: true,
        
        content_style:
            'p { '
            + 'clear: both; '
            + 'margin: 0 0 1em; '
            + '} '
            + 'img { '
            + 'display: inline-block; '
            + 'max-width: 720px; '
            + 'height: auto; '
            + 'margin-top: 16px; '
            + 'margin-bottom: 16px; '
            + '} '
            + 'iframe { '
            + 'display: inline-block; '
            + 'max-width: 100%; '
            + '}',

        height: 450,

        setup: function(editor) {
        	
        	editor.on('init', function() {
        	    const lostImages = editor.dom.select(
        	        'img[src^="/pending-content-image/"]'
        	    );

        	    if (lostImages.length === 0) {
        	        return;
        	    }

        	    lostImages.forEach(function(image) {
        	        image.remove();
        	    });

        	    editor.save();
        	    alert('입력 오류로 선택한 본문 이미지가 초기화됐습니다. 이미지를 다시 삽입해주세요.');
        	});
        	
            editor.ui.registry.addButton(
                'contentImage',
                {
                    icon: 'image',
                    tooltip: '본문 이미지 삽입',

                    onAction: function() {

                        const fileInput =
                                document.createElement('input');

                        fileInput.type = 'file';
                        fileInput.name = 'contentImages';
                        fileInput.accept =
                                'image/png, image/jpeg, image/gif, image/webp';
                        fileInput.hidden = true;

                        fileInput.addEventListener(
                            'change',
                            function() {

                                const file =
                                        fileInput.files[0];

                                if (!file) {
                                    return;
                                }

                                const token =
                                        'content-image-'
                                        + Date.now()
                                        + '-'
                                        + contentImageSequence++;

                                fileInput.dataset.uploadToken =
                                        token;

                                const tokenInput =
                                        document.createElement(
                                            'input'
                                        );

                                tokenInput.type = 'hidden';
                                tokenInput.name =
                                        'contentImageTokens';
                                tokenInput.value = token;

                                const inputContainer =
                                        document.querySelector(
                                            '#contentImageInputs'
                                        );

                                inputContainer.appendChild(
                                    fileInput
                                );

                                inputContainer.appendChild(
                                    tokenInput
                                );

                                const previewUrl =
                                        URL.createObjectURL(
                                            file
                                        );

                                const imageHtml =
                                        editor.dom.createHTML(
                                            'img',
                                            {
                                                src: previewUrl,
                                                alt: file.name,
                                                'data-upload-token':
                                                    token
                                            }
                                        );
                                
                                const imageBlockHtml =
                                    '<p style="text-align: left;">'
                                    + imageHtml
                                    + '</p>'
                                    + '<p><br></p>';

                                editor.insertContent(imageBlockHtml);
                            },
                            {
                                once: true
                            }
                        );

                        fileInput.click();
                    }
                }
            );
        }
    });
    
    const boardRegisterForm = document.querySelector('#boardRegisterForm');
	
	boardRegisterForm.addEventListener('submit', function() {
	    	
			const editor = tinymce.get('content');
	
	        const contentImages = editor.dom.select('img[data-upload-token]');
	
	        contentImages.forEach(function(image) {
	
	                const token = image.getAttribute('data-upload-token');
	
	                image.setAttribute('src', '/pending-content-image/' + token);
	
	                image.removeAttribute('data-upload-token');
	            }
	        );
	
	        // 변경된 TinyMCE HTML을 textarea에 반영한다.
	        editor.save();
	    }
	);
</script>

</body>
</html>