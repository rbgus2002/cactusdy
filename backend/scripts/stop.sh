#!/usr/bin/env bash

PROJECT_ROOT="/home/ubuntu/groupstudy"
JAR_FILE="$PROJECT_ROOT/groupstudy-app.jar"

TIME_NOW=$(date +%c)

# 현재 구동 중인 애플리케이션 pid 확인
CURRENT_PID=$(pgrep -f $JAR_FILE)

# 프로세스가 켜져 있으면 종료
if [ ! -z $CURRENT_PID ]; then
  kill -15 $CURRENT_PID
fi