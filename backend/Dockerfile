FROM eclipse-temurin:11-jre
WORKDIR /app

# 빌드된 JAR 파일 복사
COPY build/libs/*.jar app.jar

# FCM 키 파일 복사
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
