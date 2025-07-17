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

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]