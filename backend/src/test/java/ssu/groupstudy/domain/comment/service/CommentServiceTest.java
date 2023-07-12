package ssu.groupstudy.domain.comment.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class CommentServiceTest extends ServiceTest {
    @InjectMocks
    private CommentService commentService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private NoticeRepository noticeRepository;
    @Mock
    private CommentRepository commentRepository;

    @Test
    @DisplayName("존재하지 않는 사용자가 댓글을 작성하면 예외를 던진다")
    void userNotFound(){
        // given, when
        doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

        // then
        assertThatThrownBy(() -> commentService.createComment(댓글1CreateRequest))
                .isInstanceOf(UserNotFoundException.class)
                .hasMessage(ResultCode.USER_NOT_FOUND.getMessage());
    }

    @Test
    @DisplayName("존재하지 않는 공지사항에 댓글을 작성하면 예외를 던진다")
    void noticeNotFound(){
        // given, when
        doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.empty()).when(noticeRepository).findByNoticeId(any(Long.class));

        // then
        assertThatThrownBy(() -> commentService.createComment(댓글1CreateRequest))
                .isInstanceOf(NoticeNotFoundException.class)
                .hasMessage(ResultCode.NOTICE_NOT_FOUND.getMessage());
    }

    @Test
    @DisplayName("댓글을 생성한다")
    void createNotice(){
        // given
        doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
        doReturn(댓글1).when(commentRepository).save(any(Comment.class));

        // when
        Long commentId = commentService.createComment(댓글1CreateRequest);

        // then
        assertThat(commentId).isNotNull();
    }

}