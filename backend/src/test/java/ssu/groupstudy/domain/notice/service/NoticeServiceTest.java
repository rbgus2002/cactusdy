package ssu.groupstudy.domain.notice.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ssu.groupstudy.domain.notice.domain.Notice;
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

    private CreateNoticeRequest getCreateNoticeRequest(){
        return CreateNoticeRequest.builder()
                .userId(1L)
                .studyId(1L)
                .title("notice")
                .contents("contents")
                .build();
    }

    @Test
    @DisplayName("공지생성_실패_유저존재하지않음")
    void 공지생성_실패_유저존재하지않음(){
        // given
        doReturn(Optional.empty()).when(userRepository).findByUserId(any(Long.class));

        // when
        UserNotFoundException exception = assertThrows(UserNotFoundException.class, () -> noticeService.createNotice(getCreateNoticeRequest()));

        // then
        assertThat(exception.getResultCode()).isEqualTo(ResultCode.USER_NOT_FOUND);
    }

    @Test
    @DisplayName("공지생성_실패_스터디존재하지않음")
    void 공지생성_실패_스터디존재하지않음(){
        // given
        doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

        // when
        StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> noticeService.createNotice(getCreateNoticeRequest()));

        // then
        assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
    }

    @Test
    @DisplayName("공지생성_성공")
    void 공지생성_성공(){
        // given
        doReturn(Optional.of(getUser())).when(userRepository).findByUserId(any(Long.class));
        doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
        doReturn(getCreateNoticeRequest().toEntity(getUser(), getStudy())).when(noticeRepository).save(any(Notice.class));

        // when
        Notice notice = noticeService.createNotice(getCreateNoticeRequest());

        // then
        assertThat(notice).isNotNull();
        assertThat(notice.getTitle()).isEqualTo("notice");
        assertThat(notice.getWriter().getProfile().getName()).isEqualTo("최규현");
    }
}