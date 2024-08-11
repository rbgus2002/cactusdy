package ssu.groupstudy.domain.task.param;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;

import java.util.Set;
import java.util.stream.Collectors;

@Getter
public class TaskWithProgressParam {
    private Double taskProgress;
    private Set<TaskParam> tasks;

    private TaskWithProgressParam(RoundParticipantEntity roundParticipant) {
        this.taskProgress = roundParticipant.calculateTaskProgress();
        this.tasks = roundParticipant.getTasks().stream()
                .map(TaskParam::from)
                .collect(Collectors.toSet());
    }

    public static TaskWithProgressParam of(RoundParticipantEntity roundParticipant) {
        return new TaskWithProgressParam(roundParticipant);
    }
}
