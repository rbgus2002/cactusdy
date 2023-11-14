package ssu.groupstudy.domain.notice.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeInfoResponse {
    private Long noticeId;
    private String title;
    private String contents;
    private String writerNickname;
    private Long writerId;
    private boolean read;

    private int checkNoticeCount;

    private LocalDateTime createDate;

    private NoticeInfoResponse(Notice notice, User user) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.checkNoticeCount = notice.getCheckNotices().size();
        this.createDate = notice.getCreateDate();
        this.writerNickname = notice.getWriter().getNickname();
        this.writerId = notice.getWriter().getUserId();
        this.read = notice.isRead(user);
    }

    public static NoticeInfoResponse of(Notice notice, User user){
        return new NoticeInfoResponse(notice, user);
    }
}
