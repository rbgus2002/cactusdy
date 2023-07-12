package ssu.groupstudy.domain.comment.repository;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.common.RepositoryTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class CommentRepositoryTest extends RepositoryTest {
    @Test
    @DisplayName("공지사항에 작성된 댓글을 시간 순으로 가져온다")
    void getCommentsOrderByCreateDateAsc(){
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);
        noticeRepository.save(공지사항1);
        commentRepository.save(댓글1);
        commentRepository.save(댓글2);

        // when
        List<Comment> comments = commentRepository.findCommentsByNoticeOrderByCreateDate(공지사항1);

        // then
        assertEquals(2, comments.size());
        assertEquals(댓글1, comments.get(0));
        assertEquals(댓글2, comments.get(1));
    }
}