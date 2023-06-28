package ssu.groupstudy.domain.notice.dto.response;

import lombok.*;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class
NoticeSummary {
    private Long noticeId;
    private String title;
    private String contents;
    private String writerNickname;
    private char pinYn;
    private LocalDateTime createDate;

    public NoticeSummary(Notice notice) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.writerNickname = notice.getWriter().getName();
        this.pinYn = notice.getPinYn();
        this.createDate = notice.getCreateDate();
    }
}

