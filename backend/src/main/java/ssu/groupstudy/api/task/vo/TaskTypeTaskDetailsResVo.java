package ssu.groupstudy.api.task.vo;

import lombok.Getter;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.task.param.TaskParam;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Getter
public class TaskTypeTaskDetailsResVo {
    private TaskType taskType;
    private String taskTypeName;
    private List<TaskDetailResVo> tasks;

    private TaskTypeTaskDetailsResVo(TaskType taskType, Set<TaskParam> tasks) {
        this.taskType = taskType;
        this.taskTypeName = taskType.getDetail();
        this.tasks = tasks.stream()
                .filter(task -> task.getTaskType() == (taskType))
                .sorted(Comparator.comparing(TaskParam::getDoneYn, Comparator.reverseOrder())
                        .thenComparing(TaskParam::getTaskId))
                .map(TaskDetailResVo::from)
                .collect(Collectors.toList());
    }

    public static TaskTypeTaskDetailsResVo of(TaskType taskType, Set<TaskParam> tasks) {
        return new TaskTypeTaskDetailsResVo(taskType, tasks);
    }

    @Getter
    static class TaskDetailResVo {
        private Long taskId;
        private char doneYn;
        private String detail;

        private TaskDetailResVo(TaskParam task) {
            this.taskId = task.getTaskId();
            this.doneYn = task.getDoneYn();
            this.detail = task.getDetail();
        }

        public static TaskDetailResVo from(TaskParam task) {
            return new TaskDetailResVo(task);
        }
    }
}
