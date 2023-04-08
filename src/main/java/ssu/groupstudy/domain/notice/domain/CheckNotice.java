package ssu.groupstudy.domain.notice.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@IdClass(CheckNoticeKey.class)
public class CheckNotice {
    @Id
    @ManyToOne
    @JoinColumn(name="notice_id", nullable = false)
    private Notice notice;

    @Id
    @ManyToOne
    @JoinColumn(name="user_id", nullable = false)
    private User user;
}