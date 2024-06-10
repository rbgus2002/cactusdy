package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.user.entity.UserEntity;

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
    private Double taskProgress;
    private List<TaskGroup> taskGroups;

    private TaskResponse(RoundParticipantEntity roundParticipant) {
        this.roundParticipantId = roundParticipant.getId();
        this.statusTag = roundParticipant.getStatusTag();

        UserEntity user = roundParticipant.getUser();
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getPicture();

        this.taskProgress = roundParticipant.calculateTaskProgress();

        this.taskGroups = Stream.of(TaskType.values())
                .map(taskType -> TaskGroup.of(taskType, roundParticipant))
                .collect(Collectors.toList());
    }

    public static TaskResponse from(RoundParticipantEntity roundParticipant){
        return new TaskResponse(roundParticipant);
    }
}
