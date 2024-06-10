package ssu.groupstudy.domain.auth.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class InvalidLoginException extends BusinessException {
    public InvalidLoginException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public InvalidLoginException(ResultCode resultCode) {
        super(resultCode);
    }
}
