package ssu.groupstudy.domain.comment.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(Notice notice);

    List<Comment> findCommentsByParentCommentOrderByCreateDate(Comment comment);

    Long countCommentByNotice(Notice notice);
}
