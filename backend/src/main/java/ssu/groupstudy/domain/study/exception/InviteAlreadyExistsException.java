package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class InviteAlreadyExistsException extends BusinessException {
    public InviteAlreadyExistsException(ResultCode resultCode) {
        super(resultCode);
    }
}
