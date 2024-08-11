package ssu.groupstudy.api.task.vo;

import lombok.Getter;
import ssu.groupstudy.domain.common.enums.StatusTag;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.domain.round.param.RoundParticipantParam;
import ssu.groupstudy.domain.round.param.RoundTaskParam;
import ssu.groupstudy.domain.task.param.TaskParam;
import ssu.groupstudy.domain.task.param.TaskWithProgressParam;
import ssu.groupstudy.domain.user.param.UserParam;

import java.util.Comparator;
import java.util.List;
import java.util.Set;
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

    @Getter
    static class TaskTypeTaskDetailsResVo {
        private TaskType taskType;
        private String taskTypeName;
        private List<TaskDetailResVo> tasks;

        private TaskTypeTaskDetailsResVo(TaskType taskType, Set<TaskParam> tasks) {
            this.taskType = taskType;
            this.taskTypeName = taskType.getDetail();
            this.tasks = tasks.stream()
                    .filter(task -> task.getTaskType() == (taskType))
                    .sorted(Comparator.comparing(TaskParam::getDoneYn, Comparator.reverseOrder())
                            .thenComparing(TaskParam::getTaskId))
                    .map(TaskDetailResVo::from)
                    .collect(Collectors.toList());
        }

        public static TaskTypeTaskDetailsResVo of(TaskType taskType, Set<TaskParam> tasks) {
            return new TaskTypeTaskDetailsResVo(taskType, tasks);
        }

        @Getter
        static class TaskDetailResVo {
            private Long taskId;
            private char doneYn;
            private String detail;

            private TaskDetailResVo(TaskParam task) {
                this.taskId = task.getTaskId();
                this.doneYn = task.getDoneYn();
                this.detail = task.getDetail();
            }

            public static TaskDetailResVo from(TaskParam task) {
                return new TaskDetailResVo(task);
            }
        }
    }
}
