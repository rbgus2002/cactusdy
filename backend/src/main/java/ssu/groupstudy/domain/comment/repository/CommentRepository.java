package ssu.groupstudy.domain.comment.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    /**
     * 시간 순으로 모든 부모 댓글을 가져온다
     */
    List<Comment> findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(Notice notice);

    List<Comment> findCommentsByParentCommentOrderByCreateDate(Comment comment);


    @Query("SELECT COUNT(c) FROM Comment c WHERE c.notice = :notice AND c.deleteYn = 'N'")
    Long countCommentByNotice(Notice notice);
}
