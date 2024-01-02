package ssu.groupstudy.domain.task.dto.response;

import lombok.Getter;

@Getter
public class GroupTaskInfoResponse {
    private Long taskId;
    private Long roundParticipantId;
    private Long userId;

    private GroupTaskInfoResponse(Long taskId, Long roundParticipantId, Long userId) {
        this.taskId = taskId;
        this.roundParticipantId = roundParticipantId;
        this.userId = userId;
    }

    public static GroupTaskInfoResponse of(Long taskId, Long roundParticipantId, Long userId) {
        return new GroupTaskInfoResponse(taskId, roundParticipantId, userId);
    }
}
