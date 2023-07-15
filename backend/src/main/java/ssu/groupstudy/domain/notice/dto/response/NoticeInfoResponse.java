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

    private Long commentCount;

    private NoticeInfoResponse(Notice notice, Long commentCount) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.checkNoticeCount = notice.getCheckNotices().size();
        this.createDate = notice.getCreateDate();
        this.writerNickname = notice.getWriter().getNickname();
        this.commentCount = commentCount;
    }

    public static NoticeInfoResponse of(Notice notice, Long commentCount){
        return new NoticeInfoResponse(notice, commentCount);
    }
}
