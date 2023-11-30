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
    private Long writerId;
    private char pinYn;
    private LocalDateTime createDate;
    private int commentCount;
    private int readCount;
    private boolean read;

    private NoticeSummary(Notice notice, int commentCount, int readCount, boolean isRead) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.writerNickname = notice.getWriter().getNickname();
        this.writerId = notice.getWriter().getUserId();
        this.pinYn = notice.getPinYn();
        this.createDate = notice.getCreateDate();
        this.commentCount = commentCount;
        this.readCount = readCount;
        this.read = isRead;
    }

    private NoticeSummary(Notice notice) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.writerNickname = notice.getWriter().getNickname();
        this.pinYn = notice.getPinYn();
        this.createDate = notice.getCreateDate();;
    }

    public static NoticeSummary from(Notice notice){
        return new NoticeSummary(notice);
    }

    public static NoticeSummary of(Notice notice, int commentCount, int readCount, boolean isRead){
        return new NoticeSummary(notice, commentCount, readCount, isRead);
    }
}

