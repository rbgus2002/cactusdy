package ssu.groupstudy.global.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ResultCode {
    // 200 (정상)
    OK(200, "Success"),


    // 400
    DUPLICATE_PHONE_NUMBER(400, "이미 존재하는 휴대폰번호에요"),
    INVALID_METHOD_ARGUMENT(400, "잘못된 인자입니다"),
    NULL_VALUE_ERROR(400, "Null 값이 올 수 없습니다"),
    DUPLICATE_INVITE_USER(400, "이미 초대된 사용자에요"),
    INVALID_TYPE(400, "잘못된 타입입니다"),
    INVALID_JSON(400, "request 정보를 읽을 수 없습니다"),
    INVALID_COLOR(400, "잘못된 색상 입력입니다"),
    INVALID_LOGIN(400, "잘못된 아이디 혹은 비밀번호에요"),
    INVALID_PHONE_NUMBER(400, "잘못된 휴대폰 번호에요"),
    INVALID_PASSWORD(400, "잘못된 비밀번호에요"),
    NOT_SATISFIED_DB_CONSTRAINT(400, "DB의 제약조건을 만족하지 않습니다"),
    USER_NOT_PARTICIPATED(400, "스터디에 참여 중인 사용자가 아니에요"),
    HOST_USER_CAN_NOT_LEAVE_STUDY(400, "다른 멤버가 있을때, 방장은 탈퇴할 수 없어요"),
    USER_CAN_NOT_CREATE_STUDY(400, "스터디는 최대 5개까지만 생성할 수 있어요"),
    USER_CAN_NOT_CREATE_ROUND(400, "회차 최대 30개까지만 생성할 수 있어요"),
    INVALID_TASK_ACCESS(400, "본인이 생성한 태스크만 접근이 가능합니다"),
    HOST_USER_ONLY_CAN_DELETE_ROUND(400, "방장만 회차를 삭제할 수 있습니다"),
    USER_CAN_NOT_KICK_PARTICIPANT(400, "방장만 스터디 회원을 강퇴할 수 있어요"),

    // 401,
    UNAUTHORIZED(401, "인증되지 않은 사용자입니다"),

    // 403
    FORBIDDEN(403, "권한이 없는 사용자입니다"),

    // 404
    USER_NOT_FOUND(404, "존재하지 않는 사용자에요"),
    HOST_USER_NOT_FOUND(404, "방장이 존재하지 않아요"),
    STUDY_NOT_FOUND(404, "존재하지 않는 스터디에요"),
    STUDY_INVITE_CODE_NOT_FOUND(404, "존재하지 않는 코드번호에요"),
    NOTICE_NOT_FOUND(404, "존재하지 않는 공지사항이에요"),
    ROUND_NOT_FOUND(404, "존재하지 않는 회차에요"),
    ROUND_PARTICIPANT_NOT_FOUND(404, "존재하지 않는 회차 멤버에요"),
    COMMENT_NOT_FOUND(404, "존재하지 않는 댓글이에요"),
    TASK_NOT_FOUND(404, "존재하지 않는 과제에요"),
    PARTICIPANT_NOT_FOUND(404, "존재하지 않는 멤버에요"),
    PHONE_NUMBER_NOT_FOUND(404, "존재하지 않는 휴대폰번호에요"),
    RULE_NOT_FOUND(404, "존재하지 않는 규칙이에요"),


    // 405
    METHOD_NOT_ALLOWED(405, "대상 리소스가 이 메서드를 지원하지 않습니다"),


    // 500
    INTERNAL_SERVER_ERROR(500, "서버에서 문제가 발생했어요"),
    ;

    private final int statusCode;
    private final String message;
}