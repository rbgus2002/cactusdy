# 작업 계획서

1. 인프라 템플릿 작성 및 빠른 검증 가능 상태로 정리
   - docker-compose.yml 예시(traefik, backend, nginx, 볼륨/labels)
   - nginx.conf 예시(/images -> /data/uploads 매핑, 캐시 헤더, autoindex off)
   - /data/uploads 생성 및 권한 가이드
2. 정적 서빙 빠른 테스트 가이드 제공
   - /data/uploads 하위 테스트 파일 배치 후 `/images/...` 접근 확인
3. 라우팅/경로 규칙 확정 반영
   - `/api/**` -> backend, `/images/**` -> nginx
   - key 규칙: `profile/{type}/{id}/{uuid}.{ext}` 유지
4. S3 제거 범위 정리 및 반영
   - 의존성/설정/유틸/사용처 제거 또는 대체
5. 백엔드 스토리지 서비스 스케치 및 적용 예시
   - save/delete/keyToPath/keyToUrl 설계
   - 이미지 검증(MIME) 및 확장자 결정
   - editUser/editStudy 분기 및 기존 파일 삭제 best-effort
6. 운영 포인트 정리
   - 권한/백업/삭제 실패 허용 정책
