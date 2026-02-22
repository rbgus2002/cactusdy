# 저장소 가이드라인

## 프로젝트 구조 및 모듈 구성
- `src/main/java/ssu/groupstudy`: Spring Boot 애플리케이션 코드.
  - `api/`: REST 컨트롤러 및 요청/응답 VO.
  - `domain/`: 엔티티, 리포지토리, 서비스, 비즈니스 규칙.
  - `global/`: 공통 설정, 보안, 예외 처리, 유틸리티.
- `src/main/resources`: 애플리케이션 설정(YAML), 정적 리소스.
- `src/test/java/ssu/groupstudy`: 도메인별 단위/통합 테스트.
- `src/test/resources`: 테스트 설정 및 SQL 픽스처(`sql/create.sql`, `sql/insert.sql`).
- `scripts/`: 로컬 시작/중지 스크립트.

## 빌드, 테스트, 개발 명령어
- `./gradlew build`: 컴파일 및 전체 검사 실행.
- `./gradlew bootRun`: 애플리케이션을 8080 포트에서 실행.
- `./gradlew test`: 전체 테스트 실행.
- `./gradlew test --tests "ssu.groupstudy.domain.study.service.StudyServiceTest"`: 특정 테스트 클래스 실행.
- `./gradlew test jacocoTestReport`: 커버리지 리포트 생성.
- `docker-compose up -d`: 로컬 개발용 의존 서비스(MySQL/Redis) 실행.

## 코딩 스타일 및 네이밍 규칙
- Java 11, Spring Boot 2.7.x 기준의 일반적인 Java/Spring 관례 준수.
- 들여쓰기: 공백 4칸, 탭 사용 금지.
- 패키지: 소문자(`ssu.groupstudy.domain`), 클래스: `PascalCase`, 메서드/필드: `camelCase`.
- 엔티티 기본 타입: `BaseEntity` 또는 `BaseWithSoftDeleteEntity` 상속.
- 자동 포매터 없음; 주변 코드 스타일에 맞춰 작성.

## 테스트 가이드라인
- 프레임워크: JUnit(Gradle `test`), 테스트 DB는 H2 사용.
- `src/test/java` 하위에 패키지 구조를 그대로 유지.
- 테스트 클래스명은 `*Test` (예: `RoundServiceTest`).
- 서비스/리포지토리 단위 테스트 우선, 컨트롤러 테스트로 API 연결 확인.

## 커밋 및 PR 가이드라인
- 최근 커밋은 이슈 번호 + крат은 요약 형식 사용(예: `#265 댓글 생성 API...`).
- 커밋 메시지는 간결하게, 가능하면 이슈/PR 번호 포함.
- PR에는 요약, 연결된 이슈, 실행한 테스트, 설정 변경 영향 포함.
- API 변경이 Swagger/외부 문서에 영향이 있을 때만 스크린샷 추가.

## 설정 및 보안 팁
- 프로파일: `local`, `prod`, `test` (테스트는 H2 사용).
- 시크릿은 환경 변수로 관리하고 API 키/서비스 계정은 커밋 금지.
- Swagger UI는 활성화 시 `/api-docs`에서 제공.

## 문서 작성
- 문서 작성 시  /docs 하위에 파일 생성해.