package ssu.groupstudy.domain.notice.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class NoticeNotFoundException extends BusinessException {
    public NoticeNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
