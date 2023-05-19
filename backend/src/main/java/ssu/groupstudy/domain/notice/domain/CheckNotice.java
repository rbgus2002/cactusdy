package ssu.groupstudy.domain.notice.domain;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

import javax.persistence.*;
import java.io.Serializable;


@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CheckNotice{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="notice_id", nullable = false)
    private Notice notice;

    @ManyToOne
    @JoinColumn(name="user_id", nullable = false)
    private User user;

    public CheckNotice(Notice notice, User user){
        this.notice = notice;
        this.user = user;
    }
}