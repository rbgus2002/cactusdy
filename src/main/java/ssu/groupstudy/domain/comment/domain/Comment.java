package ssu.groupstudy.domain.comment.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;

import java.time.LocalDateTime;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Comment extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long commentId;

    @Column(nullable = false, length = 100)
    private String contents;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User writer;

    @ManyToOne
    @JoinColumn(name="parentCommentId")
    private Comment parentComment;

    @Column(nullable = false)
    private LocalDateTime createTime;

    @Column(nullable = false)
    private LocalDateTime modifiedTime;

    @Column(nullable = false)
    private char deleteYn;

    @ManyToOne
    @JoinColumn(name="noticeId")
    private Notice notice;
}