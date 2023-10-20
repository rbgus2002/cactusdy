package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InvalidColorException extends BusinessException {
    public InvalidColorException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public InvalidColorException(ResultCode resultCode) {
        super(resultCode);
    }
}
