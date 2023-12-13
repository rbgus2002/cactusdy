package ssu.groupstudy.domain.study.service;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@RequiredArgsConstructor
public class StudyTopicUnsubscribeEvent {
    private final User user;
    private final Study study;

    public Long getStudyId(){
        return study.getStudyId();
    }
}

