package ssu.groupstudy.domain.notice.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;

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
    class 공지사항생성 {
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

        // TODO : 구현하기 (정상동작 X)
//        @Test
//        @DisplayName("스터디에 참여중이지 않은 경우 예외를 던진다.")
//        void fail_notInvitedUser(){
//            // given
//            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
//            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByStudyId(any(Long.class));
//            doReturn(공지사항1).when(noticeRepository).save(any(Notice.class));
//
//            // when
//            Notice notice = noticeService.createNotice(공지사항1CreateRequest);
//            System.out.println("알고리즘스터디.isParticipated(최규현) = " + 알고리즘스터디.isParticipated(최규현));
//
//
//            // then
//        }

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

//    @Nested
//    class 공지사항체크 {
//        @Test
//        @DisplayName("공지사항을 읽지 않은 사용자가 체크 버튼을 누르면 읽음 처리한다.")
//        void 버튼클릭_추가() {
//            // given
//            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
//            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
//
//            // when
//            String isChecked = noticeService.switchCheckNotice(SwitchCheckNoticeRequest.builder()
//                    .noticeId(-1L)
//                    .userId(-1L)
//                    .build());
//
//            // then
////            assertThat(notice).isNotNull();
////            assertThat(notice.getCheckNotices().size()).isEqualTo(1);
//            assertThat(isChecked).isEqualTo("Checked");
//        }
//
//        @Test
//        @DisplayName("공지사항을 이미 읽은 사용자가 체크 버튼을 누르면 안읽음 처리한다.")
//        void 버튼클릭_삭제() {
//            // given
//            doReturn(Optional.of(공지사항1)).when(noticeRepository).findByNoticeId(any(Long.class));
//            doReturn(Optional.of(최규현)).when(userRepository).findByUserId(any(Long.class));
//
//            // when
//            noticeService.switchCheckNotice(new SwitchCheckNoticeRequest(-1L, -1L));
//            String isChecked = 공지사항1.switchCheckNotice(최규현);
//
//            // then
//            assertThat(공지사항1).isNotNull();
//            assertThat(isChecked).isEqualTo("Unchecked");
//        }
//    }
}