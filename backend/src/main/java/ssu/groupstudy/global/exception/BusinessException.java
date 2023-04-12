package ssu.groupstudy.global.exception;

import lombok.Builder;
import lombok.Getter;
import ssu.groupstudy.global.error.ErrorCode;

@Getter
public class BusinessException extends RuntimeException {

    private ErrorCode errorCode;

    @Builder
    public BusinessException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    @Builder
    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}
