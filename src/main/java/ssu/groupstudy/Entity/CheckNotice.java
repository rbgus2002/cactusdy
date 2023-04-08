package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;
import ssu.groupstudy.Entity.Key.CheckNoticeKey;

@Entity
@NoArgsConstructor
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