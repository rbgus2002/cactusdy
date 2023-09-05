package ssu.groupstudy.domain.task.dto;

import lombok.Getter;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;

@Getter
public class TaskDto {
    private Long taskId;
    private char doneYn;
    private TaskType taskType;
    private String detail;

    private TaskDto(Task task) {
        this.taskId = task.getTaskId();
        this.doneYn = task.getDoneYn();
        this.taskType = task.getTaskType();
        this.detail = task.getDetail();
    }

    public static TaskDto from(Task task){
        return new TaskDto(task);
    }
}
