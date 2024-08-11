package ssu.groupstudy.domain.task.param;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.task.entity.TaskEntity;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class TaskParam {
    private Long taskId;
    private TaskType taskType;
    private char doneYn;
    private String detail;

    private TaskParam(TaskEntity taskEntity){
        this.taskId = taskEntity.getId();
        this.taskType = taskEntity.getTaskType();
        this.doneYn = taskEntity.getDoneYn();
        this.detail = taskEntity.getDetail();
    }

    public static TaskParam from(TaskEntity taskEntity){
        return new TaskParam(taskEntity);
    }
}
