package ssu.groupstudy.domain.notice.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.common.entity.BaseEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.persistence.*;
import java.util.Objects;

import static javax.persistence.FetchType.LAZY;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "check_notice")
public class CheckNoticeEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "check_notice_id")
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "notice_id", nullable = false)
    private NoticeEntity notice;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    public CheckNoticeEntity(NoticeEntity notice, UserEntity user) {
        this.notice = notice;
        this.user = user;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof CheckNoticeEntity)) {
            return false;
        }
        CheckNoticeEntity that = (CheckNoticeEntity) o;
        return Objects.equals(this.notice.getNoticeId(), that.getNotice().getNoticeId()) && Objects.equals(this.user.getUserId(), that.getUser().getUserId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(notice.getNoticeId(), user.getUserId());
    }
}