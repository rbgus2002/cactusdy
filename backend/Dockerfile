# 실행 스테이지 (멀티스테이지 빌드 사용하지 않음 - JAR 파일을 직접 복사)
FROM openjdk:11-jre-slim
WORKDIR /app

# 빌드된 JAR 파일 복사 (CI/CD에서 전달)
COPY build/libs/*.jar app.jar

# FCM 키 파일 복사 (CI/CD에서 전달) - src/main/resources 경로에서 복사
COPY src/main/resources/studygroup-fcm.json /app/studygroup-fcm.json

# 환경변수 설정
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/studygroup-fcm.json

EXPOSE 8080

# JVM 옵션 추가
ENTRYPOINT ["java", \
  "--illegal-access=warn", \
  "-Dcom.amazonaws.sdk.disableEc2Metadata=true", \
  "-Dspring.profiles.active=prod", \
  "-jar", \
  "app.jar"]