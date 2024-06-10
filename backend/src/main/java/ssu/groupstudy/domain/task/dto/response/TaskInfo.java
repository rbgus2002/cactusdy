package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.task.entity.TaskEntity;

@Getter
public class TaskInfo {
    private Long taskId;
    private char doneYn;
    private String detail;

    private TaskInfo(TaskEntity task) {
        this.taskId = task.getId();
        this.doneYn = task.getDoneYn();
        this.detail = task.getDetail();
    }

    public static TaskInfo from(TaskEntity task){
        return new TaskInfo(task);
    }
}
