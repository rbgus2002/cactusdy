package ssu.groupstudy.domain.task.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class TaskNotFoundException extends BusinessException {
    public TaskNotFoundException(ResultCode resultCode, String message) {
        super(resultCode, message);
    }

    public TaskNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
