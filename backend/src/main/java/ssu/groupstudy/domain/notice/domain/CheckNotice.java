package ssu.groupstudy.domain.notice.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.*;
import java.util.Objects;

import static javax.persistence.FetchType.LAZY;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "check_notice")
public class CheckNotice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "notice_id", nullable = false)
    private Notice notice;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public CheckNotice(Notice notice, User user) {
        this.notice = notice;
        this.user = user;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o){
            return true;
        }
        if (!(o instanceof CheckNotice)) {
            return false;
        }
        CheckNotice that = (CheckNotice) o;
        return Objects.equals(this.notice.getNoticeId(), that.getNotice().getNoticeId()) && Objects.equals(this.user.getUserId(), that.getUser().getUserId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(notice.getNoticeId(), user.getUserId());
    }
}