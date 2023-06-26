package ssu.groupstudy.domain.notice.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
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

import static org.assertj.core.api.Assertions.assertThatThrownBy;
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
    
    @Nested
    class createNotice {
        @Test
        @DisplayName("사용자가 존재하지 않는 경우 예외를 던진다")
        void fail_notFoundUser() {
            // given
            doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(UserNotFoundException.class)
                    .hasMessage(USER_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디에 참여중이지 않은 경우 예외를 던진다.")
        void fail_notInvitedUser(){
            // given
            doReturn(Optional.of(장재우)).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));

            // when
            assertThatThrownBy(() -> noticeService.createNotice(공지사항1CreateRequest))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(USER_NOT_PARTICIPATED.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(공지사항1).when(noticeRepository).save(any(Notice.class));

            // when
            Notice notice = noticeService.createNotice(공지사항1CreateRequest);

            // then
            assertThat(notice).isEqualTo(공지사항1);
        }
    }

    @Nested
    class switchCheckNotice {
        @Test
        @DisplayName("스터디에 참여중이지 않은 경우 예외를 던진다.")
        void fail_userNotParticipated(){
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(장재우)).when(userRepository).findByUserId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.switchCheckNotice(-1L, -1L))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(USER_NOT_PARTICIPATED.getMessage());
        }

        @Test
        @DisplayName("공지사항을 읽지 않은 사용자가 체크 버튼을 누르면 읽음 처리한다.")
        void read() {
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));

            // when
            String isChecked = noticeService.switchCheckNotice(-1L, -1L);

            // then
            assertThat(isChecked).isEqualTo("Checked");
        }

        @Test
        @DisplayName("공지사항을 이미 읽은 사용자가 체크 버튼을 누르면 안읽음 처리한다.")
        void unread() {
            // given
            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));

            // when
            공지사항1.switchCheckNotice(최규현);
            String isChecked = noticeService.switchCheckNotice(-1L, -1L);

            // then
            assertThat(isChecked).isEqualTo("Unchecked");
        }
    }

    @Nested
    class getNoticeList{

        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void fail_studyNotFound(){
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when, then
            assertThatThrownBy(() -> noticeService.getNoticeSummaryList(-1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(STUDY_NOT_FOUND.getMessage());
        }
        @Test
        @DisplayName("스터디에 작성된 공지사항 목록을 불러온다")
        void success(){
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
            List<Notice> tmpNoticeList = new ArrayList<>();
            tmpNoticeList.add(공지사항1);
            doReturn(tmpNoticeList).when(noticeRepository).findNoticeByStudy(any(Study.class));

            // when
            List<NoticeSummary> noticeList = noticeService.getNoticeSummaryList(-1L);

            // then
            System.out.println(noticeList.get(0).getTitle());
            assertThat(noticeList.size()).isEqualTo(1);
        }
    }
}