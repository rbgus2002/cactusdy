package ssu.groupstudy.domain.notice.domain;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.io.Serializable;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CheckNotice implements Serializable {
    @Id
    @ManyToOne
    @JoinColumn(name="notice_id", nullable = false)
    private Notice notice;

    @Id
    @ManyToOne
    @JoinColumn(name="user_id", nullable = false)
    private User user;
}