package ssu.groupstudy.domain.notice.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.assertj.core.api.Assertions.assertThat;
import static ssu.groupstudy.global.ResultCode.*;


class NoticeServiceTest extends ServiceTest {
    @InjectMocks
    private NoticeService noticeService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private StudyRepository studyRepository;
    @Mock
    private NoticeRepository noticeRepository;
    @Mock
    private CommentRepository commentRepository;
    
    @Nested
    class createNotice {
        @Test
        @DisplayName("사용자가 존재하지 않는 경우 예외를 던진다")
        void fail_notFoundUser() {
            // given
            doReturn(Optional.empty()).when(userRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디에 참여중이지 않은 경우 예외를 던진다.")
        void fail_notInvitedUser(){
            // given
            doReturn(Optional.of(장재우)).when(userRepository).findById(any(Long.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));

            // when
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(USER_NOT_PARTICIPATED.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));
            doReturn(공지사항1).when(noticeRepository).save(any(Notice.class));

            // when
            Long noticeId = noticeService.createNotice(공지사항1CreateRequest);

            // then
            assertThat(noticeId).isNotNull();
        }
    }

    @Nested
    class switchCheckNotice {
//        @Test
//        @DisplayName("스터디에 참여중이지 않은 경우 예외를 던진다.")
//        void fail_userNotParticipated(){
//            // given
//            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
//            doReturn(Optional.of(장재우)).when(userRepository).findById(any(Long.class));
//
//            // when, then
//            assertThatThrownBy(() -> noticeService.switchCheckNotice(-1L, -1L))
//                    .isInstanceOf(UserNotParticipatedException.class)
//                    .hasMessage(USER_NOT_PARTICIPATED.getMessage());
//        }

        @Test
        @DisplayName("공지사항을 읽지 않은 사용자가 체크 버튼을 누르면 읽음 처리한다.")
        void read() {
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));

            // when
            Character isChecked = noticeService.switchCheckNotice(-1L, -1L);

            // then
            assertThat(isChecked).isEqualTo('Y');
        }

        @Test
        @DisplayName("공지사항을 이미 읽은 사용자가 체크 버튼을 누르면 안읽음 처리한다.")
        void unread() {
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));

            // when
            공지사항1.switchCheckNotice(최규현);
            Character isChecked = noticeService.switchCheckNotice(-1L, -1L);

            // then
            assertThat(isChecked).isEqualTo('N');
        }
    }

    @Nested
    class getNoticeSummaryList{
        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void studyNotFound(){
            // given
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.getNoticeSummaries(-1L, -1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("사용자가 존재하지 않는 경우 예외를 던진다")
        void userNotFound(){
            // given
            // when
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));
            doReturn(Optional.empty()).when(userRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> noticeService.getNoticeSummaries(-1L, -1L))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(USER_NOT_FOUND.getMessage());

        }
        @Test
        @DisplayName("스터디에 작성된 공지사항 목록을 불러온다")
        void success(){
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));
            doReturn(Optional.of(최규현)).when(userRepository).findById(any(Long.class));
            doReturn(List.of(공지사항1, 공지사항2, 공지사항3, 공지사항4)).when(noticeRepository).findNoticesByStudyOrderByPinYnDescCreateDateDesc(any(Study.class));
            doReturn(1).when(commentRepository).countCommentByNotice(any(Notice.class));

            // when
            List<NoticeSummary> noticeList = noticeService.getNoticeSummaries(-1L, -1L);

            // then
            assertThat(noticeList.size()).isEqualTo(4);
        }

        @Nested
        class getNoticeListLimit3 {
            @Test
            @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
            void fail_studyNotFound() {
                // given
                doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

                // when, then
                assertThatThrownBy(() -> noticeService.getNoticeSummaryListLimit3(-1L))
                        .isInstanceOf(StudyNotFoundException.class)
                        .hasMessage(STUDY_NOT_FOUND.getMessage());
            }

            @Test
            @DisplayName("스터디에 작성된 공지사항 목록을 최대 3개 불러온다")
            void success() {
                // given
                doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));
                doReturn(List.of(공지사항1, 공지사항2, 공지사항3)).when(noticeRepository).findTop3ByStudyOrderByPinYnDescCreateDateDesc(any(Study.class));

                // when
                List<NoticeSummary> noticeList = noticeService.getNoticeSummaryListLimit3(-1L);

                // then
                assertThat(noticeList.size()).isEqualTo(3);
            }
        }


        @Nested
        class switchNoticePin{
            @Test
            @DisplayName("공지사항이 존재하지 않는 경우 예외를 던진다")
            void fail_noticeNotFound(){
                // given
                doReturn(Optional.empty()).when(noticeRepository).findByNoticeId(any(Long.class));

                // when, then
                assertThatThrownBy(() -> noticeService.switchNoticePin(-1L))
                        .isInstanceOf(NoticeNotFoundException.class)
                        .hasMessage(NOTICE_NOT_FOUND.getMessage());
            }

            @Test
            @DisplayName("공지사항을 상단고정하도록 상태를 변경한다")
            void pin(){
                // given, when
                Character pinYn = 공지사항1.switchPin();

                // then
                assertThat(pinYn).isEqualTo('Y');
            }
        }

        // FIXME
        @Test
        @DisplayName("공지사항에 체크 표시를 한 사용자 프로필 사진 리스트를 불러온다")
        void getCheckUserImageListByNoticeId(){
            // given

            // when
            공지사항1.switchCheckNotice(최규현);
            Set<CheckNotice> checkNotices = 공지사항1.getCheckNotices();
            List<String> profileImageList = new ArrayList<>();
            for(CheckNotice checkNotice : checkNotices){
                profileImageList.add(checkNotice.getUser().getPicture());
            }

            // then
            assertThat(profileImageList.size()).isEqualTo(1);
        }
    }


    @Nested
    class deleteNotice{
        @Test
        @DisplayName("공지사항이 존재하지 않는 경우 예외를 던진다")
        void fail_noticeNotFound(){
            // given
            doReturn(Optional.empty()).when(noticeRepository).findByNoticeId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.delete(-1L))
                    .isInstanceOf(NoticeNotFoundException.class)
                    .hasMessage(NOTICE_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("공지사항을 삭제한다")
        void success(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));

            // when
            noticeService.delete(-1L);
            
            // then
            assertEquals('Y', 공지사항1.getDeleteYn());
        }
    }
}