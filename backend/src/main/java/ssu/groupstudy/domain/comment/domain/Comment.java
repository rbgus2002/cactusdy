package ssu.groupstudy.domain.comment.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Where(clause = "delete_yn = 'N'")
public class Comment extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long commentId;

    @Column(nullable = false, length = 100)
    private String contents;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="userId", nullable = false)
    private User writer;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="noticeId")
    private Notice notice;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="parentCommentId")
    private Comment parentComment;

    @Column(nullable = false)
    private char deleteYn;

    public Comment(String contents, User writer, Notice notice) {
        this.contents = contents;
        this.writer = writer;
        this.notice = notice;
        this.deleteYn = 'N';
        this.parentComment = null;
    }

    public Comment(String contents, User writer, Notice notice, Comment parentComment) {
        this.contents = contents;
        this.writer = writer;
        this.notice = notice;
        this.parentComment = parentComment;
    }
}