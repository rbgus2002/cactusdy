package ssu.groupstudy.domain.notice.dto.response;

import lombok.*;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeSummary {
    private String title;
    private String contents;
    private String nickName;
    private LocalDateTime createDate;

    public NoticeSummary(Notice notice) {
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.nickName = notice.getWriter().getName();
        this.createDate = notice.getCreateDate();
    }
}

