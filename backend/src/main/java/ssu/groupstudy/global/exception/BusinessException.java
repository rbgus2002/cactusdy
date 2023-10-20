package ssu.groupstudy.global.exception;

import lombok.Builder;
import lombok.Getter;
import ssu.groupstudy.global.constant.ResultCode;

@Getter
public class BusinessException extends RuntimeException {
    private ResultCode resultCode;

    @Builder
    public BusinessException(ResultCode resultCode, String message) {
        super(message);
        this.resultCode = resultCode;
    }

    @Builder
    public BusinessException(ResultCode resultCode) {
        super(resultCode.getMessage());
        this.resultCode = resultCode;
    }
}
