package ssu.groupstudy.domain.notice.param;

import lombok.*;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeSummary { // [2024-06-10:최규현] TODO: param 변경
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

    private NoticeSummary(NoticeEntity notice, int commentCount, int readCount, boolean isRead) {
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

    private NoticeSummary(NoticeEntity notice) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.writerNickname = notice.getWriter().getNickname();
        this.pinYn = notice.getPinYn();
        this.createDate = notice.getCreateDate();;
    }

    public static NoticeSummary from(NoticeEntity notice){
        return new NoticeSummary(notice);
    }

    public static NoticeSummary of(NoticeEntity notice, int commentCount, int readCount, boolean isRead){
        return new NoticeSummary(notice, commentCount, readCount, isRead);
    }
}

