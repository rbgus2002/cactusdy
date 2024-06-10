package ssu.groupstudy.domain.common.exception;

import lombok.Builder;
import lombok.Getter;
import ssu.groupstudy.domain.common.enums.ResultCode;

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
