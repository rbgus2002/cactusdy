package ssu.groupstudy.api.task.vo;

import lombok.Getter;
import ssu.groupstudy.domain.task.entity.TaskEntity;

@Getter
public class TaskInfo { // [2024-06-10:최규현] TODO: inner class로 변경해야함
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
