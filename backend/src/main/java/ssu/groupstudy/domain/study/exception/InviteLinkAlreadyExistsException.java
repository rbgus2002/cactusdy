package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.error.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InviteLinkAlreadyExistsException extends BusinessException {
    public InviteLinkAlreadyExistsException(ResultCode resultCode) {
        super(resultCode);
    }
}
