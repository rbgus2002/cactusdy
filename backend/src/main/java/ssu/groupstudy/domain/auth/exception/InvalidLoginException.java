package ssu.groupstudy.domain.auth.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InvalidLoginException extends BusinessException {
    public InvalidLoginException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public InvalidLoginException(ResultCode resultCode) {
        super(resultCode);
    }
}
