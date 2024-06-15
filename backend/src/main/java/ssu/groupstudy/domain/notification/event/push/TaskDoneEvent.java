package ssu.groupstudy.domain.notification.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class TaskDoneEvent {
    private final UserEntity user;
    private final TaskEntity task;
    private final StudyEntity study;
    private final RoundEntity round;

    public Long getStudyId() {
        return study.getStudyId();
    }

    public Long getRoundId() {
        return round.getRoundId();
    }

    public String getStudyName() {
        return study.getStudyName();
    }

    public String getNickname() {
        return user.getNickname();
    }

    public String getTaskDetail() {
        return task.getDetail();
    }
}
