package ssu.groupstudy.domain.notice.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeInfoResponse {
    private Long noticeId;
    private String title;
    private String contents;
    private int checkNoticeCount;
    private LocalDateTime createDate;
    private String writerNickname;

    private NoticeInfoResponse(Notice notice) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.checkNoticeCount = notice.getCheckNotices().size();
        this.createDate = notice.getCreateDate();
        this.writerNickname = notice.getWriter().getNickname();
    }

    public static NoticeInfoResponse from(Notice notice){
        return new NoticeInfoResponse(notice);
    }

    @Override
    public String toString() {
        return "NoticeInfoResponse{" +
                "noticeId=" + noticeId +
                ", title='" + title + '\'' +
                ", contents='" + contents + '\'' +
                ", checkNoticeCount=" + checkNoticeCount +
                ", createDate=" + createDate +
                ", writerNickname='" + writerNickname + '\'' +
                '}';
    }
}
