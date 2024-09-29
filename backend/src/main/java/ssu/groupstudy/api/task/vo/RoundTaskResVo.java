package ssu.groupstudy.api.task.vo;

import lombok.Getter;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.round.param.RoundParticipantParam;
import ssu.groupstudy.domain.round.param.RoundTaskParam;
import ssu.groupstudy.domain.task.param.TaskWithProgressParam;
import ssu.groupstudy.domain.user.param.UserParam;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Getter
public class RoundTaskResVo {
    // userEntity
    private Long userId;
    private String nickname;
    private String profileImage;


    // roundParticipantEntity
    private Long roundParticipantId;
    private StatusTag statusTag;


    // task
    private Double taskProgress;
    private List<TaskTypeTaskDetailsResVo> taskGroups;

    private RoundTaskResVo(RoundTaskParam roundTaskParam) {
        UserParam user = roundTaskParam.getUser();
        this.userId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getProfileImage();

        RoundParticipantParam roundParticipant = roundTaskParam.getRoundParticipant();
        this.roundParticipantId = roundParticipant.getRoundParticipantId();
        this.statusTag = roundParticipant.getStatusTag();

        TaskWithProgressParam taskWithProgress = roundTaskParam.getTaskWithProgress();
        this.taskProgress = taskWithProgress.getTaskProgress();
        this.taskGroups = Stream.of(TaskType.values())
                .map(taskType -> TaskTypeTaskDetailsResVo.of(taskType, taskWithProgress.getTasks()))
                .collect(Collectors.toList());
    }

    public static RoundTaskResVo from(RoundTaskParam roundTaskParam) {
        return new RoundTaskResVo(roundTaskParam);
    }
}
