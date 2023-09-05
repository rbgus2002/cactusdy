package ssu.groupstudy.domain.task.dto;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.task.domain.Task;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class TaskResponse {
    private Long roundParticipantId;
    private Long userId;
    private List<TaskDto> tasks;

    private TaskResponse(RoundParticipant roundParticipant) {
        this.roundParticipantId = roundParticipant.getId();
        this.userId = roundParticipant.getUser().getUserId();
        this.tasks = roundParticipant.getTasks().stream()
                .sorted(Comparator.comparing(Task::getTaskType)
                        .thenComparing(Task::getTaskId))
                .map(TaskDto::from)
                .collect(Collectors.toList());
    }

    // TODO : 객체 이름을 어떻게 하면 좋을지 더 고민해보기
    public static TaskResponse from(RoundParticipant roundParticipant){
        return new TaskResponse(roundParticipant);
    }
}
