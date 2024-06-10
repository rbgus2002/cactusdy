package ssu.groupstudy.domain.comment.domain;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.user.domain.UserEntity;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "comment")
public class Comment extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long commentId;

    @Column(nullable = false, length = 255)
    private String contents;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="userId", nullable = false)
    private UserEntity writer;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="noticeId")
    private Notice notice;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="parentCommentId")
    private Comment parentComment;

    @Column(nullable = false)
    private char deleteYn;

    public Comment(String contents, UserEntity writer, Notice notice) {
        this.contents = contents;
        this.writer = writer;
        this.notice = notice;
        this.deleteYn = 'N';
        this.parentComment = null;
    }

    public Comment(String contents, UserEntity writer, Notice notice, Comment parentComment) {
        this.contents = contents;
        this.writer = writer;
        this.notice = notice;
        this.deleteYn = 'N';
        this.parentComment = parentComment;
    }

    public void delete() {
        this.deleteYn = 'Y';
    }

    public boolean isDeleted(){
        return this.deleteYn == 'Y';
    }
}