#!/usr/bin/env bash

PROJECT_ROOT="/home/ubuntu/groupstudy"
JAR_FILE="$PROJECT_ROOT/groupstudy-app.jar"

ERROR_LOG="$PROJECT_ROOT/error.log"
APP_LOG="$PROJECT_ROOT/app.log"

TIME_NOW=$(date +%c)

# build 파일 복사
cp $PROJECT_ROOT/build/libs/*.jar $JAR_FILE

# jar 파일 실행
nohup java --illegal-access=warn -Dcom.amazonaws.sdk.disableEc2Metadata=true -jar $JAR_FILE > $APP_LOG 2> $ERROR_LOG &