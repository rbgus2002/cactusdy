package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.domain.StatusTag;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Getter
public class TaskResponse {
    private Long roundParticipantId;
    private StatusTag statusTag;
    private Long userId;
    private String nickname;
    private String profileImage;
    private Double taskProgress; // TODO : 태스크 진행율 구현 예정
    private List<TaskGroups> taskGroups;

    private TaskResponse(RoundParticipant roundParticipant) {
        this.roundParticipantId = roundParticipant.getId();
        this.statusTag = roundParticipant.getStatusTag();

        User user = roundParticipant.getUser();
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getPicture();

        this.taskProgress = 0.7;

        taskGroups = Stream.of(TaskType.values())
                .map(taskType -> TaskGroups.of(taskType, roundParticipant))
                .collect(Collectors.toList());
    }

    // TODO : 객체 이름을 어떻게 하면 좋을지 더 고민해보기
    public static TaskResponse from(RoundParticipant roundParticipant){
        return new TaskResponse(roundParticipant);
    }
}
