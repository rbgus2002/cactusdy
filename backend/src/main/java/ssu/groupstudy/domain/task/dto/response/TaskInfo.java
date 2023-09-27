package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.task.domain.Task;

@Getter
public class TaskInfo {
    private Long taskId;
    private char doneYn;
    private String detail;

    private TaskInfo(Task task) {
        this.taskId = task.getId();
        this.doneYn = task.getDoneYn();
        this.detail = task.getDetail();
    }

    public static TaskInfo from(Task task){
        return new TaskInfo(task);
    }
}
