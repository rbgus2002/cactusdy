package ssu.groupstudy.domain.notification.domain.event.push;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@RequiredArgsConstructor
public class TaskDoneEvent{
    private final User user;
    private final Task task;

    public Long getStudyId(){
        return task.getStudy().getStudyId();
    }

    public String getStudyName(){
        return task.getStudy().getStudyName();
    }

    public String getNickname(){
        return user.getNickname();
    }

    public String getTaskDetail(){
        return task.getDetail();
    }
}
