package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class ParticipantNotFoundException extends BusinessException {
    public ParticipantNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public ParticipantNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
