package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class TaskGroup {
    private String taskType;
    private List<TaskInfo> tasks;

    private TaskGroup(TaskType taskType, RoundParticipant roundParticipant) {
        this.taskType = taskType.getDetail();
        this.tasks = roundParticipant.getTasks().stream()
                .filter(task -> task.isSameTypeOf(taskType))
                .sorted(Comparator.comparing(Task::getDoneYn)
                        .thenComparing(Task::getId))
                .map(TaskInfo::from)
                .collect(Collectors.toList());
    }

    public static TaskGroup of(TaskType type, RoundParticipant roundParticipant){
        return new TaskGroup(type, roundParticipant);
    }
}