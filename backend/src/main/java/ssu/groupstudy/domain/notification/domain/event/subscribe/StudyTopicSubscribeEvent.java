package ssu.groupstudy.domain.notification.domain.event.subscribe;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.entity.UserEntity;

@Getter
@RequiredArgsConstructor
public class StudyTopicSubscribeEvent {
    private final UserEntity user;
    private final Study study;

    public Long getStudyId(){
        return study.getStudyId();
    }
}
