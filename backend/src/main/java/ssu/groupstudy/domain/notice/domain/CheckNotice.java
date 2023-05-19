package ssu.groupstudy.domain.notice.domain;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CheckNotice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "notice_id", nullable = false)
    private Notice notice;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public CheckNotice(Notice notice, User user) {
        this.notice = notice;
        this.user = user;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;

        final CheckNotice that = (CheckNotice) o;
        return Objects.equals(notice, that.notice) && Objects.equals(user, that.user);
    }

    @Override
    public int hashCode() {
        return Objects.hash(notice, user);
    }
}