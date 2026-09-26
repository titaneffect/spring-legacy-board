<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title><c:out value="${board.title}"/> 수정</title>

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
                            게시글 수정
                        </h1>

                        <p>
                            게시글 내용과 첨부파일을 수정할 수 있습니다.
                        </p>

                    </header>

                    <form id="modifyForm"
                          method="post"
                          enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}/modify">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <input type="hidden"
                               name="bno"
                               value="${board.bno}">

                        <input type="hidden"
                               name="page"
                               value="${pageRequest.page}">

                        <input type="hidden"
                               name="size"
                               value="${pageRequest.size}">

                        <input type="hidden"
                               name="type"
                               value="${fn:escapeXml(pageRequest.type)}">

                        <input type="hidden"
                               name="keyword"
                               value="${fn:escapeXml(pageRequest.keyword)}">

                        <input type="hidden"
                               name="writer"
                               value="${fn:escapeXml(board.writer)}">

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
                                   value="${fn:escapeXml(board.title)}">

                        </div>

                        <!-- 내용 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="content">
                                내용
                            </label>

                            <textarea class="form-control cafe-content-input"
                                      id="content"
                                      name="content"><c:out value="${board.content}"/></textarea>

                        </div>

                        <!-- 기존 첨부파일 -->
                        <c:if test="${not empty attachList}">

                            <section class="cafe-existing-attachments mb-4">

                                <h2>
                                    기존 첨부파일
                                </h2>

                                <p>
                                    삭제할 파일의 X 버튼을 누른 후
                                    수정 버튼을 눌러주세요.
                                </p>

                                <div class="cafe-existing-attachment-grid">

                                    <c:forEach var="attach"
                                               items="${attachList}">

                                        <div class="existing-attach cafe-existing-attachment"
                                             data-ano="${attach.ano}">

                                            <c:choose>

                                                <c:when test="${fn:startsWith(
                                                        attach.contentType,
                                                        'image/')}">

                                                    <img src="${pageContext.request.contextPath}/attachments/${attach.ano}/view"
                                                         alt="${fn:escapeXml(attach.fileName)}">

                                                </c:when>

                                                <c:otherwise>

                                                    <div class="cafe-file-placeholder">
                                                        FILE
                                                    </div>

                                                </c:otherwise>

                                            </c:choose>

                                            <span class="cafe-existing-file-name">
                                                <c:out value="${attach.fileName}"/>
                                            </span>

                                            <button class="attach-remove-button"
                                                    type="button"
                                                    aria-label="${fn:escapeXml(attach.fileName)} 삭제">
                                                ×
                                            </button>

                                        </div>

                                    </c:forEach>
                                </div>
                            </section>
                        </c:if>

                        <!-- 새 첨부파일 -->
                        <div class="mb-4">

                            <label class="form-label fw-semibold"
                                   for="uploadFiles">
                                새 첨부파일
                            </label>

                            <input class="form-control"
                                   type="file"
                                   id="uploadFiles"
                                   name="uploadFiles"
                                   multiple>

                            <div class="form-text">
                                기존 파일은 유지되고 선택한 파일이 추가됩니다.
                            </div>

                        </div>

                        <!-- TinyMCE에서 새로 선택한 본문 이미지 보관 -->
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

                        <!-- 수정 버튼 -->
                        <div class="cafe-form-actions">

                            <a class="btn btn-outline-secondary"
                               href="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}?${fn:escapeXml(pageRequest.link)}">
                                취소
                            </a>

                            <button class="btn cafe-primary-button"
                                    type="submit">
                                수정 완료
                            </button>

                        </div>
                    </form>
                </section>

                <!-- 게시글 삭제 -->
                <section class="cafe-danger-zone mt-4">

                    <div>
                        <strong>
                            게시글 삭제
                        </strong>

                        <p>
                            게시글과 댓글, 첨부파일이 모두 삭제됩니다.
                        </p>
                    </div>

                    <form method="post"
                          action="${pageContext.request.contextPath}/cafe/${cafeId}/board/${cafeBoard.cafeBoardId}/post/${board.bno}/remove"
                          onsubmit="return confirm('게시글을 삭제하시겠습니까?');">

                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">

                        <input type="hidden"
                               name="bno"
                               value="${board.bno}">

                        <button class="btn btn-outline-danger"
                                type="submit">
                            게시글 삭제
                        </button>

                    </form>
                </section>

            </section>
        </div>
    </main>

    <dialog id="kakaoPlaceDialog"
	        class="border rounded-3 p-4 shadow"
	        style="width: min(90vw, 700px);">
	    <h2 class="h5 mb-3">장소 삽입</h2>

	    <div class="d-flex gap-2 mb-3">
	        <input id="placeKeyword"
	               class="form-control"
	               type="text"
	               placeholder="장소 이름을 검색하세요">
	        <button id="placeSearchButton"
	                class="btn btn-outline-primary"
	                type="button">검색</button>
	    </div>

	    <div id="placeResult" class="mb-2"></div>
	    <div id="placeList" class="list-group mb-3"></div>
	    <div id="placeMap" style="width:100%; height:300px;"></div>

	    <div class="text-end mt-3">
	    	<button id="insertPlaceButton"
			        class="btn cafe-primary-button"
			        type="button"
			        disabled>본문에 삽입</button>

	        <button id="closePlaceDialog"
	                class="btn btn-outline-secondary"
	                type="button">닫기</button>
	    </div>
	</dialog>

    <!-- 기존 첨부파일 삭제 예약 JavaScript -->

    <script>
        const modifyForm =
            document.querySelector('#modifyForm');

        const removeButtons =
            document.querySelectorAll(
                '.attach-remove-button'
            );

        removeButtons.forEach(button => {

            button.addEventListener(
                'click',
                function () {

                    const attachItem =
                        button.closest(
                            '.existing-attach'
                        );

                    const ano =
                        attachItem.dataset.ano;

                    const hiddenInput =
                        document.createElement('input');

                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'deleteAnoList';
                    hiddenInput.value = ano;

                    modifyForm.appendChild(hiddenInput);

                    attachItem.style.display = 'none';
                }
            );
        });
    </script>

	<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=d518e991a40570dc43d9b870e07871e0&libraries=services"></script>
	<script>
	    let contentImageSequence = 0;

	    let placeBookmark = null;
	    let placeMap = null;
	    let placeMarker = null;
	    let selectedPlace = null;
	    const placeSearch = new kakao.maps.services.Places();

	    tinymce.init({
	        selector: '#content',

	        plugins: 'lists link table media image',

	        toolbar: 'undo redo | blocks fontfamily fontsize | '
	                + 'bold italic underline | '
	                + 'alignleft aligncenter alignright | '
	                + 'bullist numlist | table link contentImage media kakaoPlace',

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

	        	editor.ui.registry.addButton('kakaoPlace', {
	        	    text: '장소 삽입',
	        	    tooltip: '카카오맵 장소 삽입',
	        	    onAction: function () {
	        	        placeBookmark = editor.selection.getBookmark(2, true);

	        	        selectedPlace = null;

	        	        document.getElementById('placeKeyword').value = '';
	        	        document.getElementById('placeResult').textContent = '';
	        	        document.getElementById('placeList').replaceChildren();

	        	        if (placeMarker) {
	        	            placeMarker.setMap(null);
	        	            placeMarker = null;
	        	        }

	        	        document.getElementById('insertPlaceButton').disabled = true;

	        	        document.getElementById('kakaoPlaceDialog').showModal();

	        	        if (!placeMap) {
	        	            placeMap = new kakao.maps.Map(
	        	                document.getElementById('placeMap'),
	        	                {
	        	                    center: new kakao.maps.LatLng(
	        	                    		37.495062742517085,
	        	                    	    127.12249058886933
	        	                   	),
	        	                    level: 3
	        	                }
	        	            );
	        	        } else {
	        	            placeMap.relayout();
	        	            placeMap.setCenter(new kakao.maps.LatLng(
	        	            		37.495062742517085,
    	                    	    127.12249058886933
    	                   	));
	        	        }
	        	    }
	        	});

  	            editor.ui.registry.addButton(
	                'contentImage',
	                {
	                    icon: 'image',
	                    tooltip: '본문 이미지 삽입',

	                    onAction: function() {

	                        const fileInput = document.createElement('input');

	                        fileInput.type = 'file';
	                        fileInput.name = 'contentImages';
	                        fileInput.accept =
	                                'image/png, image/jpeg, image/gif, image/webp';
	                        fileInput.hidden = true;

	                        fileInput.addEventListener('change', function() {

	                                const file = fileInput.files[0];

	                                if (!file) {
	                                    return;
	                                }

	                                const token = 'content-image-'
			                                        + Date.now()
			                                        + '-'
			                                        + contentImageSequence++;

	                                const tokenInput = document.createElement('input');

	                                tokenInput.type = 'hidden';
	                                tokenInput.name = 'contentImageTokens';
	                                tokenInput.value = token;

	                                const inputContainer = document.querySelector('#contentImageInputs');

	                                inputContainer.appendChild(fileInput);

	                                inputContainer.appendChild(tokenInput);

	                                const previewUrl = URL.createObjectURL(file);

	                                const imageHtml = editor.dom.createHTML('img', {
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

	    document.getElementById('placeSearchButton')
	    .addEventListener('click', function () {
	        const keyword = document.getElementById('placeKeyword').value.trim();
	        const resultArea = document.getElementById('placeResult');
	        const placeList = document.getElementById('placeList');

	        placeList.replaceChildren();
	        selectedPlace = null;
	        document.getElementById('insertPlaceButton').disabled = true;

	        if (!keyword) {
	            resultArea.textContent = '검색어를 입력하세요.';
	            return;
	        }

	        placeSearch.keywordSearch(keyword, function (results, status) {
	            if (status !== kakao.maps.services.Status.OK) {
	                resultArea.textContent =
	                    '검색 결과가 없거나 검색에 실패했습니다.';
	                return;
	            }

	            resultArea.textContent = '삽입할 장소를 선택하세요.';

	            results.forEach(function (place) {
	                const button = document.createElement('button');
	                button.type = 'button';
	                button.className =
	                    'list-group-item list-group-item-action';

	                const address =
	                    place.road_address_name || place.address_name;
	                button.textContent =
	                    place.place_name + ' — ' + address;

	                button.addEventListener('click', function () {
	                    const position = new kakao.maps.LatLng(
	                        Number(place.y), Number(place.x)
	                    );

	                    placeMap.setCenter(position);

	                    if (placeMarker) {
	                        placeMarker.setMap(null);
	                    }

	                    placeMarker = new kakao.maps.Marker({
	                        map: placeMap,
	                        position: position
	                    });

	                    selectedPlace = place;
		                document.getElementById('insertPlaceButton').disabled = false;

		                resultArea.textContent = '선택한 장소: ' + place.place_name;
		                placeList.replaceChildren(); // 선택했으므로 검색 결과 목록을 접는다
	                });

	                placeList.appendChild(button);
	            });
	        });
	    });

	    document.getElementById('insertPlaceButton')
	    .addEventListener('click', function () {
	        if (!selectedPlace) {
	            return;
	        }

	        const lat = Number(selectedPlace.y);
	        const lng = Number(selectedPlace.x);

	        if (!Number.isFinite(lat) || lat < -90 || lat > 90
	                || !Number.isFinite(lng) || lng < -180 || lng > 180) {
	            alert('장소 좌표가 올바르지 않습니다.');
	            return;
	        }

	        const link = document.createElement('a');
	        link.href = 'https://map.kakao.com/link/map/' + lat + ',' + lng;
	        link.textContent = '📍 ' + selectedPlace.place_name;

	        const paragraph = document.createElement('p');
	        paragraph.appendChild(link);

	        document.getElementById('kakaoPlaceDialog').close();

	        const editor = tinymce.get('content');
	        editor.focus();

	        if (placeBookmark) {
	            editor.selection.moveToBookmark(placeBookmark);
	        }

	        editor.insertContent(paragraph.outerHTML + '<p><br></p>');
	        editor.save();
	    });

	    document.getElementById('closePlaceDialog')
	    .addEventListener('click', function () {
	        document.getElementById('kakaoPlaceDialog').close();
	    });

	    /*
	     * 새로 선택한 본문 이미지만
	     * 임시 토큰 주소로 변경한다.
	     *
	     * 기존 /attachments/{ano}/view 이미지는
	     * data-upload-token이 없으므로 변경되지 않는다.
	     */
	    modifyForm.addEventListener(
	        'submit',
	        function() {

	            const editor = tinymce.get('content');

	            const newContentImages = editor.dom.select('img[data-upload-token]');

	            newContentImages.forEach(function(image) {

	                    const token = image.getAttribute('data-upload-token');

	                    image.setAttribute('src', '/pending-content-image/' + token);

	                    image.removeAttribute('data-upload-token');
	                }
	            );

	            editor.save();
	        }
	    );
	</script>

</body>
</html>