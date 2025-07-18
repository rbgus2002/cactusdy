package ssu.groupstudy.domain.common.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AlarmType {
    COMMENT_CREATED("공지사항 댓글"),
    NOTICE_CREATED("공지사항 생성"),
    TASK_COMPLETED("과제 완료"),
    MEMBER_POKE("스터디원 콕 찌르기"),
    TASK_POKE("과제 콕 찌르기");

    private final String description;
}