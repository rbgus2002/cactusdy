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
    DUPLICATE_INVITE_INFO(400, "이미 초대 정보가 존재합니다."),
    INVALID_TYPE(400, "잘못된 타입입니다."),
    INVALID_JSON(400, "request 정보를 읽을 수 없습니다."),
    NOT_SATISFIED_DB_CONSTRAINT(400, "DB의 제약조건을 만족하지 않습니다."),

    // 404
    USER_NOT_FOUND(404, "존재하지 않는 사용자입니다."),


    // 405
    METHOD_NOT_ALLOWED(405, "대상 리소스가 이 메서드를 지원하지 않습니다."),

    // 500
    INTERNAL_SERVER_ERROR(500, "서버에서 문제가 발생했습니다."),


            ;

    int statusCode;
    private final String message;
}