package ssu.groupstudy.domain.round.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

@ExtendWith(MockitoExtension.class)
class RoundServiceTest {
    @InjectMocks
    private RoundService roundService;

    @Mock
    private RoundRepository roundRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;


    private CreateRoundRequest getCreateRoundRequest() {
        return CreateRoundRequest.builder()
                .studyId(-1L)
                .studyPlace("규현집")
                .studyTime(LocalDateTime.of(2023, 5, 17, 16, 00))
                .build();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build();
    }

    private Study getStudy() {
        return getRegisterStudyRequest().toEntity(getUser());
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

    @Nested
    class 회차생성 {
        @Test
        @DisplayName("존재하지 않는 스터디에서 회차를 생성하는 경우 예외를 던진다")
        void 실패_스터디존재X() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findByStudyId(any(Long.class));

            // when
            StudyNotFoundException exception = assertThrows(StudyNotFoundException.class, () -> roundService.createRound(getCreateRoundRequest()));

            // then
            assertThat(exception.getResultCode()).isEqualTo(ResultCode.STUDY_NOT_FOUND);
        }



        @Test
        @DisplayName("회차 생성할 때 스터디 장소와 약속 시간은 Null 값으로 둘수 있다.")
        void 성공_스터디장소및시간존재X() {
            // given
            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(CreateRoundRequest.builder()
                    .studyId(-1L)
                    .build().toEntity(getStudy())).when(roundRepository).save(any(Round.class));

            // when
            Round round = roundService.createRound(CreateRoundRequest.builder()
                    .studyId(-1L)
                    .build());

            // then
            assertThat(round).isNotNull();
            assertThat(round.getAppointment().getStudyPlace()).isNull();
            assertThat(round.getAppointment().getStudyTime()).isNull();
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(getStudy())).when(studyRepository).findByStudyId(any(Long.class));
            doReturn(getCreateRoundRequest().toEntity(getStudy())).when(roundRepository).save(any(Round.class));

            // when
            Round round = roundService.createRound(getCreateRoundRequest());

            // then
            assertThat(round).isNotNull();
            assertThat(round.getAppointment().getStudyPlace()).isEqualTo("규현집");
            assertThat(round.getStudy().getStudyName()).isEqualTo("AlgorithmSSU");
        }
    }

}