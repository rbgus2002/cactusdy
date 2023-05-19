package ssu.groupstudy.domain.notice.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.SwitchCheckNoticeRequest;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.assertj.core.api.Assertions.assertThat;


@ExtendWith(MockitoExtension.class)
class NoticeServiceTest {
    @InjectMocks
    private NoticeService noticeService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;

    @Mock
    private NoticeRepository noticeRepository;

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build();
    }

    private Study getStudy() {
        return getRegisterStudyRequest().toEntity(getUser(), "", "");
    }


    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
    }

    private User getUser() {
        return getSignUpRequest().toEntity();
    }

    private CreateNoticeRequest getCreateNoticeRequest() {
        return CreateNoticeRequest.builder()
                .userId(1L)
                .studyId(1L)
                .title("notice")
                .contents("contents")
                .build();
    }

    private Notice getNotice() {
        return getCreateNoticeRequest().toEntity(getUser(), getStudy());
    }

    @Nested
    class 공지생성 {
        @Test
        @DisplayName("존재하지 않는 사용자가 공지사항을 생성하는 경우 예외를 던진다")
        void 실패_유저존재하지않음() {
            // given
            doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

            // when
            UserNotFoundException exception = assertThrows(UserNotFoundException.class, () -> noticeService.createNotice(getCreateNoticeRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.USER_NOT_FOUND);
        }

        @Test
        @DisplayName("존재하지 않는 스터디에 공지사항을 생성하는 경우 예외를 던진다")
        void 실패_스터디존재하지않음() {
            // given
            doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when
            StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> noticeService.createNotice(getCreateNoticeRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(getCreateNoticeRequest().toEntity(getUser(), getStudy())).when(noticeRepository).save(any(Notice.class));

            // when
            Notice notice = noticeService.createNotice(getCreateNoticeRequest());

            // then
            assertThat(notice).isNotNull();
            assertThat(notice.getTitle()).isEqualTo("notice");
            assertThat(notice.getWriter().getName()).isEqualTo("최규현");
        }
    }

    @Nested
    class 공지사항체크 { // TODO : 스터디 참여중인 사용자인지 고려해줘서 TEST CODE 짜기 (프로덕트 코드는 정상)
        @Test
        @DisplayName("공지사항을 읽지 않은 사용자가 체크 버튼을 누르면 읽음 처리한다.")
        void 버튼클릭_추가() {
            // given
            Notice notice = getNotice();
            doReturn(Optional.of(notice)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(SignUpRequest.builder()
                    .name("홍예지")
                    .email("yejiisfree@naver.com")
                    .nickName("play_girl")
                    .build().toEntity())).when(userRepository).findByUserId(any(Long.class));

            // when
            String isChecked = noticeService.switchCheckNotice(SwitchCheckNoticeRequest.builder()
                    .noticeId(1L)
                    .userId(1L)
                    .build());

            // then
            assertThat(notice).isNotNull();
            assertThat(notice.getCheckNotices().size()).isEqualTo(1);
            assertThat(isChecked).isEqualTo("Checked");
        }

        @Test
        @DisplayName("공지사항을 이미 읽은 사용자가 체크 버튼을 누르면 안읽음 처리한다.")
        void 버튼클릭_삭제() {
            // given
            User user = SignUpRequest.builder()
                    .name("홍예지")
                    .email("yejiisfree@naver.com")
                    .nickName("play_girl")
                    .build().toEntity();
            Notice notice = getNotice();
            doReturn(Optional.of(notice)).when(noticeRepository).findByNoticeId(any(Long.class));
            doReturn(Optional.of(user)).when(userRepository).findByUserId(any(Long.class));

            // when
            noticeService.switchCheckNotice(SwitchCheckNoticeRequest.builder()
                    .noticeId(1L)
                    .userId(1L)
                    .build());
            String isChecked = notice.switchCheckNotice(new CheckNotice(notice, user));

            // then
            assertThat(notice).isNotNull();
            assertThat(notice.getCheckNotices().size()).isEqualTo(0);
            assertThat(isChecked).isEqualTo("Unchecked");
        }

//        @Test
//        @DisplayName("공지사항 체크 버튼은 해당 스터디에 소속된 사용자만 누를 수 있다")
//        void 실패_스터디소속X() {
//            // given
//            User user = SignUpRequest.builder()
//                    .name("홍예지")
//                    .email("yejiisfree@naver.com")
//                    .nickName("play_girl")
//                    .build().toEntity();
//            doReturn(Optional.of(getNotice())).when(noticeRepository).findByNoticeId(any(Long.class));
//            doReturn(Optional.of(user)).when(userRepository).findByUserId(any(Long.class));
//
//            // when
//            noticeService.switchCheckNotice(SwitchCheckNoticeRequest.builder()
//                    .noticeId(1L)
//                    .userId(1L)
//                    .build());
//            notice.switchCheckNotice(new CheckNotice(notice, user));
//
//            // then
//            assertThat(notice).isNotNull();
//            assertThat(notice.getCheckNotices().size()).isEqualTo(0);
//        }
    }
}