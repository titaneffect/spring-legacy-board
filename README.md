# Deep Study

여러 카페와 게시판을 운영할 수 있는 Spring Legacy 기반 커뮤니티 프로젝트입니다. 사용자는 커뮤니티 계정으로 로그인한 뒤 카페에 가입 신청을 하고, 카페 소유자의 승인을 받아 활동할 수 있습니다.

## 주요 기능

- 커뮤니티 회원가입·로그인 및 Spring Security 기반 접근 제어
- 카페 생성·수정·삭제, 카페별 게시판 관리
- 카페 가입 신청·승인·거절·재신청, 탈퇴·강퇴 및 역할 변경
- 게시판별 읽기·쓰기 등급 설정 (`GUEST`, `MEMBER`, `MANAGER`, `OWNER`)
- 게시글·댓글·첨부파일 등록 및 관리
- TinyMCE를 이용한 서식 있는 글쓰기: 표, 본문 이미지, YouTube 영상, 카카오맵 장소 삽입
- 허용한 HTML만 표시하는 서버 측 본문 정화, CSRF 보호

## 기술 구성

| 영역 | 사용 기술 |
| --- | --- |
| 서버 | Java 8, Spring MVC 5.3, Spring Security 5.8 |
| 데이터 | Oracle Database, MyBatis 3.5 |
| 화면 | JSP, JSTL, Bootstrap 5, TinyMCE 8, Kakao Maps JavaScript API |
| 빌드·배포 | Maven, WAR |

## 데이터 구조

주요 테이블은 `MEMBER`, `MEMBER_AUTH`, `CAFE`, `CAFE_MEMBER`, `CAFE_BOARD`, `BOARD`, `REPLY`, `BOARD_ATTACH`입니다.

```text
MEMBER ──< CAFE_MEMBER >── CAFE ──< CAFE_BOARD ──< BOARD
                                   BOARD ──< REPLY
                                   BOARD ──< BOARD_ATTACH
```

`CAFE_MEMBER`는 커뮤니티 회원과 카페의 가입 관계를 저장합니다. 카페 역할(`OWNER`, `MANAGER`, `MEMBER`)과 가입 상태는 별개입니다.

| 가입 상태 | 의미 |
| --- | --- |
| `PENDING` | 가입 승인 대기 |
| `ACTIVE` | 활동 중 |
| `REJECTED` | 가입 신청 거절; 재신청 가능 |
| `WITHDRAWN` | 자진 탈퇴; 재신청 가능 |
| `BANNED` | 강퇴; 재신청 불가 |

일반 사용자의 가입 신청은 `PENDING`으로 저장되고, 카페 생성자는 `OWNER`·`ACTIVE`로 등록됩니다. 소유자가 신청을 승인하면 `ACTIVE`·`MEMBER`, 거절하면 `REJECTED`가 됩니다. 탈퇴하거나 거절된 사용자가 다시 신청하면 `PENDING`으로 돌아갑니다.

`CAFE_MEMBER.JOINED_AT`은 실제 가입 시각입니다. 승인 대기·거절 상태에서는 `NULL`이고, 승인할 때 기록됩니다. 카페 생성자의 가입 시각은 카페 생성 시각입니다.

> 현재 저장소에는 전체 Oracle 스키마 생성 SQL이 포함되어 있지 않습니다. 새 DB에서 실행하려면 테이블·시퀀스·제약조건 정의를 별도로 준비해야 합니다. 특히 `CAFE_MEMBER.STATUS`의 체크 제약은 위 다섯 상태를 모두 허용해야 합니다.

## 로컬 실행

1. Java 8, Maven, Oracle Database와 WAR를 실행할 서블릿 컨테이너를 준비합니다.
2. 기존 프로젝트의 Oracle 테이블·시퀀스·제약조건을 준비합니다. 이 저장소의 MyBatis 매퍼 XML은 SQL 매핑이지 스키마 생성 스크립트는 아닙니다. 기존 DB를 사용하는 경우 `sql/2026-09-26_cafe_member_joined_at.sql`을 적용합니다.
3. `src/main/resources/db.properties.example`을 `db.properties`로 복사해 본인의 DB 접속 정보를 입력합니다.
4. `src/main/resources/upload.properties.example`을 `upload.properties`로 복사해 파일 저장 경로를 지정하고 해당 디렉터리를 만듭니다.
5. Maven으로 WAR를 빌드해 서블릿 컨테이너에 배포합니다. 접속 경로는 배포한 컨텍스트 경로에 따라 달라지며, 첫 화면은 `/cafe`로 이동합니다.

실제 `db.properties`와 `upload.properties`는 Git 추적에서 제외되어 있습니다. 계정 비밀번호를 README나 예시 파일에 기록하지 마세요. 에디터와 지도 기능은 외부 서비스의 JavaScript를 사용하므로 브라우저에서 해당 서비스에 접근할 수 있어야 합니다.

## 주요 사용 흐름

1. 커뮤니티 회원가입·로그인 후 카페를 만듭니다. 생성자는 카페 소유자가 됩니다.
2. 소유자가 카페 안에 게시판을 만들고 읽기·쓰기 등급을 설정합니다.
3. 다른 회원이 카페 가입을 신청하고, 소유자가 회원 관리 화면에서 승인하거나 거절합니다.
4. 승인된 회원이 게시글을 작성합니다. 본문에는 이미지·표·YouTube 영상·카카오맵 장소를 넣을 수 있습니다.
5. 권한이 있는 사용자는 게시글과 첨부파일을 조회하고 댓글을 작성합니다.

## 추후 정리할 항목

- Oracle 전체 스키마와 누락된 변경 SQL을 저장소에 추가해 새 환경에서도 DB를 재현할 수 있게 하기
- ERD와 핵심 화면 스크린샷 추가
- 배포 환경의 HTTPS 및 외부 서비스 키 관리 정리
