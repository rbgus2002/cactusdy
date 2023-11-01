package ssu.groupstudy.domain.notification.domain.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@RequiredArgsConstructor
public class TaskDoneEvent{
    private final User user;
    private final Study study;

    public Long getStudyId(){
        return study.getStudyId();
    }
}
