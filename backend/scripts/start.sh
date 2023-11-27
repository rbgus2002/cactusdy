#!/usr/bin/env bash

PROJECT_ROOT="/home/ubuntu/groupstudy"
JAR_FILE="$PROJECT_ROOT/groupstudy-app.jar"
DEPLOY_LOG="$PROJECT_ROOT/log/deploy.log"

TIME_NOW=$(date +%c)

# build 파일 복사
cp $PROJECT_ROOT/build/libs/*.jar $JAR_FILE

# jar 파일 실행
nohup env GOOGLE_APPLICATION_CREDENTIALS=/home/ubuntu/groupstudy/credential/studygroup-fcm.json SENTRY_AUTH_TOKEN=sntrys_eyJpYXQiOjE3MDEwNjg2NzQuODcxMDQ1LCJ1cmwiOiJodHRwczovL3NlbnRyeS5pbyIsInJlZ2lvbl91cmwiOiJodHRwczovL3VzLnNlbnRyeS5pbyIsIm9yZyI6Imdyb3Vwc3R1ZHkifQ==_qxwQzLJv+8Apd6GSTgBb6jJs0YMhlgWdAkBZnlSnTt4LC_CTYPE=C.UTF-8 java --illegal-access=warn -Dcom.amazonaws.sdk.disableEc2Metadata=true -jar $JAR_FILE > $DEPLOY_LOG 2> $DEPLOY_LOG &