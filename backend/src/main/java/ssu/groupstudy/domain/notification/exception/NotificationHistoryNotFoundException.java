package ssu.groupstudy.domain.notification.exception;

import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;

public class NotificationHistoryNotFoundException extends BusinessException {
    public NotificationHistoryNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
