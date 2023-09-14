package ssu.groupstudy.global;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ResultCode {
    // 200 (정상)
    OK(200, "Success"),


    // 400
    DUPLICATE_EMAIL(400, "이미 존재하는 이메일입니다."),
    INVALID_METHOD_ARGUMENT(400, "잘못된 인자입니다."),
    NULL_VALUE_ERROR(400, "Null 값이 올 수 없습니다."),
    DUPLICATE_INVITE_USER(400, "이미 초대된 사용자입니다."),
    INVALID_TYPE(400, "잘못된 타입입니다."),
    INVALID_JSON(400, "request 정보를 읽을 수 없습니다."),
    INVALID_COLOR(400, "잘못된 색상 입력입니다."),
    NOT_SATISFIED_DB_CONSTRAINT(400, "DB의 제약조건을 만족하지 않습니다."),
    USER_NOT_PARTICIPATED(400, "스터디에 참여중인 사용자가 아닙니다."),
    HOST_USER_CAN_NOT_LEAVE_STUDY(400, "방장은 스터디에 탈퇴할 수 없습니다."),
    INVALID_TASK_ACCESS(400, "본인이 생성한 태스크만 접근이 가능합니다"),




    // 404
    USER_NOT_FOUND(404, "존재하지 않는 사용자입니다."),
    STUDY_NOT_FOUND(404, "존재하지 않는 스터디입니다."),
    NOTICE_NOT_FOUND(404, "존재하지 않는 공지사항입니다."),
    ROUND_NOT_FOUND(404, "존재하지 않는 회차입니다."),
    ROUND_PARTICIPANT_NOT_FOUND(404, "존재하지 않는 회차 참여자입니다."),
    COMMENT_NOT_FOUND(404, "존재하지 않는 댓글입니다."),
    TASK_NOT_FOUND(404, "존재하지 않는 태스크입니다."),
    PARTICIPANT_NOT_FOUND(404, "존재하지 않는 참여자입니다."),


    // 405
    METHOD_NOT_ALLOWED(405, "대상 리소스가 이 메서드를 지원하지 않습니다."),


    // 500
    INTERNAL_SERVER_ERROR(500, "서버에서 문제가 발생했습니다."),

    ;

    private final int statusCode; // TODO : HttpStatus 타입으로 리팩토링
    private final String message;
}