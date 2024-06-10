package ssu.groupstudy.domain.notification.domain.event.unsubscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.UserEntity;

@Getter
@RequiredArgsConstructor
public class StudyTopicUnsubscribeEvent {
    private final UserEntity user;
    private final Study study;

    public Long getStudyId(){
        return study.getStudyId();
    }
}

