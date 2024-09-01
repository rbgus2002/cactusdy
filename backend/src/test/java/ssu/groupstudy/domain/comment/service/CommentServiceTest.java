package ssu.groupstudy.domain.comment.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationEventPublisher;
import ssu.groupstudy.api.comment.vo.CommentInfoResVo;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.comment.exception.CommentNotFoundException;
import ssu.groupstudy.domain.comment.repository.CommentEntityRepository;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class CommentServiceTest extends ServiceTest {
    @InjectMocks
    private CommentService commentService;
    @Mock
    private UserEntityRepository userEntityRepository;
    @Mock
    private NoticeEntityRepository noticeEntityRepository;
    @Mock
    private CommentEntityRepository commentEntityRepository;
    @Mock
    private ApplicationEventPublisher eventPublisher;


    @Nested
    class CreateNotice{
        @Test
        @DisplayName("댓글을 생성한다")
        void createNotice(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeEntityRepository).findById(any(Long.class));
            doReturn(댓글1).when(commentEntityRepository).save(any(CommentEntity.class));

            // when
            Long commentId = commentService.createComment(댓글1CreateRequest, 최규현);

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
            doReturn(Optional.empty()).when(noticeEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> commentService.getComments(-1L))
                    .isInstanceOf(NoticeNotFoundException.class)
                    .hasMessage(ResultCode.NOTICE_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("공지사항에 작성된 댓글을 작성 시각 순으로 불러온다")
        void getCommentsOrderByCreateDateAsc(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeEntityRepository).findById(any(Long.class));

            // when
            CommentInfoResVo comments = commentService.getComments(-1L);

            // then
//            assertEquals(0, comments.size());
        }

        @Test
        @DisplayName("공지사항에 작성된 댓글을 가져오고 각 댓글에 대댓글이 존재하면 추가한다")
        void getCommentWithReplies(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeEntityRepository).findById(any(Long.class));

            // when
            CommentInfoResVo comments = commentService.getComments(-1L);

            // then
            System.out.println(comments);
        }
    }

    @Nested
    class deleteComment{
        @Test
        @DisplayName("존재하지 않는 댓글이면 예외를 던진다")
        void noticeNotFound(){
            // given, when
            doReturn(Optional.empty()).when(commentEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> commentService.deleteComment(-1L))
                    .isInstanceOf(CommentNotFoundException.class)
                    .hasMessage(ResultCode.COMMENT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("댓글을 삭제한다")
        void success(){
            // given
            doReturn(Optional.of(댓글1)).when(commentEntityRepository).findById(any(Long.class));

            // when
            commentService.deleteComment(-1L);

            // then
            assertTrue(댓글1.isDeleted());
        }
    }
}