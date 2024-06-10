package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.common.enums.TaskType;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class TaskGroup {
    private TaskType taskType;
    private String taskTypeName;
    private List<TaskInfo> tasks;

    private TaskGroup(TaskType taskType, RoundParticipantEntity roundParticipant) {
        this.taskType = taskType;
        this.taskTypeName = taskType.getDetail();
        this.tasks = roundParticipant.getTasks().stream()
                .filter(task -> task.isSameTypeOf(taskType))
                .sorted(Comparator.comparing(TaskEntity::getDoneYn, Comparator.reverseOrder())
                        .thenComparing(TaskEntity::getId))
                .map(TaskInfo::from)
                .collect(Collectors.toList());
    }

    public static TaskGroup of(TaskType type, RoundParticipantEntity roundParticipant){
        return new TaskGroup(type, roundParticipant);
    }
}