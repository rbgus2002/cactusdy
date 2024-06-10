package ssu.groupstudy.api.notice.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class NoticeInfoResVo {
    private Long noticeId;
    private String title;
    private String contents;
    private String writerNickname;
    private Long writerId;
    private boolean read;
    private int readCount;
    private LocalDateTime createDate;

    private NoticeInfoResVo(NoticeEntity notice, UserEntity user) {
        this.noticeId = notice.getNoticeId();
        this.title = notice.getTitle();
        this.contents = notice.getContents();
        this.readCount = notice.getCheckNotices().size();
        this.createDate = notice.getCreateDate();
        this.writerNickname = notice.getWriter().getNickname();
        this.writerId = notice.getWriter().getUserId();
        this.read = notice.isRead(user);
    }

    public static NoticeInfoResVo of(NoticeEntity notice, UserEntity user){
        return new NoticeInfoResVo(notice, user);
    }
}
