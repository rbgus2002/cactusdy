package ssu.groupstudy.domain.study.exception;

import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class ParticipantNotFoundException extends BusinessException {
    public ParticipantNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public ParticipantNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
