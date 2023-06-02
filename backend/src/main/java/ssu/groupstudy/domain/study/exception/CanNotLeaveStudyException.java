package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class CanNotLeaveStudyException extends BusinessException {
    public CanNotLeaveStudyException(ResultCode resultCode) {
        super(resultCode);
    }
}
