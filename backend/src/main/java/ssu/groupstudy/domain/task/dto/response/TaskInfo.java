package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;

@Getter
public class TaskInfo {
    private Long taskId;
    private char doneYn;
    private TaskType taskType;
    private String detail;

    private TaskInfo(Task task) {
        this.taskId = task.getId();
        this.doneYn = task.getDoneYn();
        this.taskType = task.getTaskType();
        this.detail = task.getDetail();
    }

    public static TaskInfo from(Task task){
        return new TaskInfo(task);
    }
}
