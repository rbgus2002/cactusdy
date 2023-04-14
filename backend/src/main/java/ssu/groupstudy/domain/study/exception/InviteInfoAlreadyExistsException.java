package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InviteInfoAlreadyExistsException extends BusinessException {
    public InviteInfoAlreadyExistsException(ResultCode resultCode) {
        super(resultCode);
    }
}
