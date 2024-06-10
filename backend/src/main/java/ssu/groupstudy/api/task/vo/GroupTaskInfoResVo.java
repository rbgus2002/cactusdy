package ssu.groupstudy.api.task.vo;

import lombok.Getter;

@Getter
public class GroupTaskInfoResVo {
    private Long taskId;
    private Long roundParticipantId;
    private Long userId;

    private GroupTaskInfoResVo(Long taskId, Long roundParticipantId, Long userId) {
        this.taskId = taskId;
        this.roundParticipantId = roundParticipantId;
        this.userId = userId;
    }

    public static GroupTaskInfoResVo of(Long taskId, Long roundParticipantId, Long userId) {
        return new GroupTaskInfoResVo(taskId, roundParticipantId, userId);
    }
}
