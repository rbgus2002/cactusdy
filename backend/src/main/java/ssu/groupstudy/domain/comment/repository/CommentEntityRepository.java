package ssu.groupstudy.domain.comment.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;

import java.util.List;

public interface CommentEntityRepository extends JpaRepository<CommentEntity, Long> {
    /**
     * 시간 순으로 모든 부모 댓글을 가져온다
     */
    List<CommentEntity> findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(NoticeEntity notice);

    List<CommentEntity> findCommentsByParentCommentOrderByCreateDate(CommentEntity comment);


    @Query("SELECT COUNT(c) FROM CommentEntity c WHERE c.notice = :notice AND c.deleteYn = 'N'")
    int countCommentByNotice(NoticeEntity notice);
}
