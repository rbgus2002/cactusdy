package ssu.groupstudy.domain.study.service;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.util.List;

@Getter
@RequiredArgsConstructor
public class NoticeTopicUnsubscribeEvent {
    private final User user;
    private final List<Notice> notices;
}


