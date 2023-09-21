package ssu.groupstudy.domain.task.dto;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.domain.StatusTag;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.user.domain.User;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class TaskResponse {
    private Long roundParticipantId;
    private StatusTag statusTag;
    private Long userId;
    private String nickName;
    private Double taskProgress; // TODO : 태스크 진행율 구현 예정
    private List<TaskDto> tasks;

    private TaskResponse(RoundParticipant roundParticipant) {
        this.roundParticipantId = roundParticipant.getId();
        this.statusTag = roundParticipant.getStatusTag();

        User user = roundParticipant.getUser();
        this.userId = user.getUserId();
        this.nickName = user.getNickname();

        this.taskProgress = 0.7;
        this.tasks = roundParticipant.getTasks().stream()
                .sorted(Comparator.comparing(Task::getTaskType)
                        .thenComparing(Task::getId))
                .map(TaskDto::from)
                .collect(Collectors.toList());
    }

    // TODO : 객체 이름을 어떻게 하면 좋을지 더 고민해보기
    public static TaskResponse from(RoundParticipant roundParticipant){
        return new TaskResponse(roundParticipant);
    }
}
