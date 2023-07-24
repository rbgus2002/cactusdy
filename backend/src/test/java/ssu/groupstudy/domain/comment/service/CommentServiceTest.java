package ssu.groupstudy.domain.comment.service;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.exception.CommentNotFoundException;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import javax.persistence.EntityManager;
import java.util.List;
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


    @Nested
    class CreateNotice{
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

    @Nested
    class GetComments{
        @Test
        @DisplayName("공지사항이 존재하지 않으면 예외를 던진다")
        void notFoundNotice(){
            // given, when
            doReturn(Optional.empty()).when(noticeRepository).findByNoticeId(any(Long.class));

            // then
            assertThatThrownBy(() -> commentService.getCommentsOrderByCreateDateAsc(-1L))
                    .isInstanceOf(NoticeNotFoundException.class)
                    .hasMessage(ResultCode.NOTICE_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("공지사항에 작성된 댓글을 작성 시각 순으로 불러온다")
        void getCommentsOrderByCreateDateAsc(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));

            // when
            List<CommentInfoResponse> comments = commentService.getCommentsOrderByCreateDateAsc(-1L);

            // then
            assertEquals(0, comments.size()); // TODO 테스트 고민해보기
        }

        @Test
        @DisplayName("공지사항에 작성된 댓글을 가져오고 각 댓글에 대댓글이 존재하면 추가한다")
        void getCommentWithReplies(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));

            // when
            List<CommentInfoResponse> comments = commentService.getCommentsOrderByCreateDateAsc(-1L);

            // then
            System.out.println(comments); // TODO 테스트 어케하냐.,., (일대다 연관관계 아니어서 그럼)
        }
    }

    @Nested
    class deleteComment{
        @Test
        @DisplayName("존재하지 않는 댓글이면 예외를 던진다")
        void noticeNotFound(){
            // given, when
            doReturn(Optional.empty()).when(commentRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> commentService.deleteComment(-1L))
                    .isInstanceOf(CommentNotFoundException.class)
                    .hasMessage(ResultCode.COMMENT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("댓글을 삭제한다")
        void success(){
            // given
            doReturn(Optional.of(댓글1)).when(commentRepository).findById(any(Long.class));

            // when
            commentService.deleteComment(-1L);

            // then
            assertEquals('Y', 댓글1.getDeleteYn());
        }
    }
}