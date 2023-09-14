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
        List<Comment> comments = commentRepository.findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(공지사항1);

        // then
        assertEquals(2, comments.size());
        assertEquals(댓글1, comments.get(0));
        assertEquals(댓글2, comments.get(1));
    }

    @Test
    @DisplayName("특정 댓글의 대댓글을 모두 가져온다")
    void getReplies(){
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);
        noticeRepository.save(공지사항1);
        commentRepository.save(댓글1);
        commentRepository.save(대댓글1);
        commentRepository.save(대댓글2);

        // when
        List<Comment> replies = commentRepository.findCommentsByParentCommentOrderByCreateDate(댓글1);

        // then
        assertEquals(2, replies.size());
        assertEquals(대댓글1, replies.get(0));
        assertEquals(대댓글2, replies.get(1));
    }
    
    @Test
    @DisplayName("공지사항에 작성된 댓글의 개수를 가져온다")
    void countCommentByNotice(){
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);
        noticeRepository.save(공지사항1);
        commentRepository.save(댓글1);
        commentRepository.save(대댓글1);
        commentRepository.save(대댓글2);

        // when
        Long commentCount = commentRepository.countCommentByNoticeAndDeleteYn(공지사항1, 'N');
        
        // then
        assertEquals(3, commentCount);
    }
}