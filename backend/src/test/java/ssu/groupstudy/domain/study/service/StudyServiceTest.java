package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationEventPublisher;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.rule.repository.RuleEntityRepository;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.api.study.vo.StudySummaryResVo;
import ssu.groupstudy.domain.study.exception.ParticipantNotFoundException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.util.ImageManager;
import ssu.groupstudy.domain.common.util.S3Utils;

import java.io.IOException;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class StudyServiceTest extends ServiceTest {
    @InjectMocks
    private StudyService studyService;
    @Mock
    private StudyInviteService studyInviteService;
    @Mock
    private StudyEntityRepository studyEntityRepository;
    @Mock
    private ParticipantEntityRepository participantEntityRepository;
    @Mock
    private RoundEntityRepository roundEntityRepository;
    @Mock
    private RuleEntityRepository ruleEntityRepository;
    @Mock
    private ApplicationEventPublisher eventPublisher;
    @Mock
    private ImageManager imageManager;
    @Mock
    private S3Utils s3Utils;

    @Nested
    class 스터디생성 {
        @Test
        @DisplayName("스터디를 생성하면서 스터디 색상을 지정한다.")
        void setColor() throws IOException {
            // given
            doReturn("123456").when(studyInviteService).generateUniqueInviteCode();
            doReturn(알고리즘스터디).when(studyEntityRepository).save(any(StudyEntity.class));
            doReturn(RoundEntity.builder()
                    .study(알고리즘스터디)
                    .build()).when(roundEntityRepository).save(any(RoundEntity.class));

            // when
            studyService.createStudy(알고리즘스터디CreateRequest, null, 최규현);

            // then
            ParticipantEntity participant = 알고리즘스터디.getParticipantList().get(0);
            softly.assertThat(participant.getColor()).isEqualTo(알고리즘스터디CreateRequest.getColor());
        }

        @Test
        @DisplayName("자동으로 회차가 하나 생성된다.")
        void createDefaultRound() {
            // given

            // when


            // then

        }
    }

    @Nested
    class getStudySummary {
        @Test
        @DisplayName("존재하지 않는 스터디인 경우 예외를 던진다")
        void 실패_유저존재하지않음() {
            // given, when
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> studyService.getStudySummary(-1L, null))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디 참여자가 존재하지 않는 경우 예외를 던진다")
        void participantNotFound() {
            // given
            // when
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(Optional.empty()).when(participantEntityRepository).findByUserAndStudy(any(UserEntity.class), any(StudyEntity.class));

            // then
            assertThatThrownBy(() -> studyService.getStudySummary(-1L, 최규현))
                    .isInstanceOf(ParticipantNotFoundException.class)
                    .hasMessage(ResultCode.PARTICIPANT_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void success() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(Optional.of(스터디참여자_최규현)).when(participantEntityRepository).findByUserAndStudy(any(UserEntity.class), any(StudyEntity.class));

            // when
            StudySummaryResVo summaryResponse = studyService.getStudySummary(-1L, 최규현);

            // then
            assertEquals("알고리즘", summaryResponse.getStudyName());
        }
    }

    @Nested
    class GetInviteCode {
        @Test
        @DisplayName("스터디가 존재하지 않는 경우 예외를 던진다")
        void studyNotFound(){
            // given
            // when
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> studyService.getInviteCode(-1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("스터디의 초대코드를 가져온다")
        void getInviteCode(){
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            final String originalInviteCode = 알고리즘스터디.getInviteCode();

            // when
            final String inviteCode = studyService.getInviteCode(-1L);

            // then
            softly.assertThat(inviteCode).isEqualTo(originalInviteCode);
        }
    }
}