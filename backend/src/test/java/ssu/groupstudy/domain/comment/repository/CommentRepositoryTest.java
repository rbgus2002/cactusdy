package ssu.groupstudy.domain.comment.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;

import java.util.List;

@CustomRepositoryTest
class CommentRepositoryTest{
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private NoticeRepository noticeRepository;
    @Autowired
    private CommentRepository commentRepository;

    @Test
    @DisplayName("공지사항에 작성된 댓글을 시간 순으로 가져온다")
    void getCommentsOrderByCreateDateAsc(){
        // given
        Notice 공지사항 = noticeRepository.findByNoticeId(1L).get();

        // when
        List<Comment> comments = commentRepository.findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(공지사항);
        Comment 댓글1 = comments.get(0);
        Comment 댓글2 = comments.get(1);

        // then
        softly.assertThat(댓글1.getCreateDate()).isBefore(댓글2.getCreateDate());
        softly.assertThat(댓글1.getParentComment()).isNull();
        softly.assertThat(댓글2.getParentComment()).isNull();
    }

    @Test
    @DisplayName("특정 댓글의 대댓글을 모두 가져온다")
    void getReplies(){
        // given
        Comment 댓글 = commentRepository.findById(1L).get();

        // when
        List<Comment> replies = commentRepository.findCommentsByParentCommentOrderByCreateDate(댓글);
        Comment 대댓글1 = replies.get(0);
        Comment 대댓글2 = replies.get(1);

        // then
        softly.assertThat(replies.size()).isEqualTo(2);
        softly.assertThat(대댓글1.getCreateDate()).isBefore(대댓글2.getCreateDate());
    }
    
    @Test
    @DisplayName("공지사항에 작성된 댓글의 개수를 가져온다")
    void countCommentByNotice(){
        // given
        Notice 공지사항 = noticeRepository.findByNoticeId(1L).get();

        // when
        int 댓글개수 = commentRepository.countCommentByNotice(공지사항);
        
        // then
        softly.assertThat(댓글개수).isEqualTo(4);
    }
}