package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class CanNotLeaveStudyException extends BusinessException {
    public CanNotLeaveStudyException(ResultCode resultCode) {
        super(resultCode);
    }
}
