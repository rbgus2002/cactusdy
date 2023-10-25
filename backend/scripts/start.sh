#!/usr/bin/env bash

PROJECT_ROOT="/home/ubuntu/groupstudy"
JAR_FILE="$PROJECT_ROOT/groupstudy-app.jar"
DEPLOY_LOG="$PROJECT_ROOT/log/deploy.log"

TIME_NOW=$(date +%c)

# build 파일 복사
cp $PROJECT_ROOT/build/libs/*.jar $JAR_FILE

# jar 파일 실행
nohup java --illegal-access=warn -Dcom.amazonaws.sdk.disableEc2Metadata=true -jar $JAR_FILE > $DEPLOY_LOG 2> $DEPLOY_LOG &