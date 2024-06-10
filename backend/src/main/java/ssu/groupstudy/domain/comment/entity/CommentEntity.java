package ssu.groupstudy.domain.comment.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.entity.BaseEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "comment")
public class CommentEntity extends BaseEntity {
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
    private NoticeEntity notice;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="parentCommentId")
    private CommentEntity parentComment;

    @Column(nullable = false)
    private char deleteYn;

    public CommentEntity(String contents, UserEntity writer, NoticeEntity notice) {
        this.contents = contents;
        this.writer = writer;
        this.notice = notice;
        this.deleteYn = 'N';
        this.parentComment = null;
    }

    public CommentEntity(String contents, UserEntity writer, NoticeEntity notice, CommentEntity parentComment) {
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