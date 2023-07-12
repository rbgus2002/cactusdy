package ssu.groupstudy.domain.comment.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    Comment save(Comment comment);
}
