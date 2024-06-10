package ssu.groupstudy.domain.notification.domain.event.unsubscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class StudyTopicUnsubscribeEvent {
    private final UserEntity user;
    private final StudyEntity study;

    public Long getStudyId(){
        return study.getStudyId();
    }
}

