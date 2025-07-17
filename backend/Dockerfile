# 빌드 스테이지
FROM openjdk:11-jdk-slim AS builder
WORKDIR /app

# Gradle 의존성 캐싱
COPY build.gradle gradlew ./
COPY gradle gradle
RUN ./gradlew dependencies

# 소스코드 복사 및 빌드
COPY src src
RUN ./gradlew build -x test

# 실행 스테이지
FROM openjdk:11-jre-slim
WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# FCM 키 파일 복사
COPY --from=builder /app/src/main/resources/studygroup-fcm.json /app/studygroup-fcm.json

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