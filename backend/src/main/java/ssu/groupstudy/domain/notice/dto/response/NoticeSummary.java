package ssu.groupstudy.domain.notice.dto.response;

import lombok.*;
import ssu.groupstudy.domain.notice.domain.Notice;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeSummary {
    private Long noticeId;
    private String title;
    private String contents;
    private String writerNickname;
    private char pinYn;
    private LocalDateTime createDate;
    private Long commentCount;

    private NoticeSummary(Notice notice, Long commentCount) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.writerNickname = notice.getWriter().getNickname();
        this.pinYn = notice.getPinYn();
        this.createDate = notice.getCreateDate();
        this.commentCount = commentCount;
    }

    public static NoticeSummary from(Notice notice){
        return new NoticeSummary(notice, null);
    }

    public static NoticeSummary of(Notice notice, Long commentCount){
        return new NoticeSummary(notice, commentCount);
    }
}

