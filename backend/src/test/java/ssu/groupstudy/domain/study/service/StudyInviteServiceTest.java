package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationEventPublisher;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundParticipantEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantEntityRepository;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.ResultCode;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class StudyInviteServiceTest extends ServiceTest {
    @InjectMocks
    private StudyInviteService studyInviteService;
    @Mock
    private StudyEntityRepository studyEntityRepository;
    @Mock
    private RoundEntityRepository roundEntityRepository;
    @Mock
    private ParticipantEntityRepository participantEntityRepository;
    @Mock
    private RoundParticipantEntityRepository roundParticipantEntityRepository;
    @Mock
    private NoticeEntityRepository noticeEntityRepository;
    @Mock
    private ApplicationEventPublisher eventPublisher;

    @Nested
    class inviteUser {
        @Test
        @DisplayName("참여 중인 스터디가 5개 이상이면 예외를 던진다")
        void canNotCreateStudy(){
            // given
            // when
            doReturn(5).when(participantEntityRepository).countParticipationStudy(any(UserEntity.class));

            // then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, "000000"))
                    .isInstanceOf(CanNotCreateStudyException.class)
                    .hasMessage(ResultCode.USER_CAN_NOT_CREATE_STUDY.getMessage());
        }

        @Test
        @DisplayName("스터디가 존재하지 않으면 예외를 던진다")
        void studyNotFound() {
            // given
            doReturn(4).when(participantEntityRepository).countParticipationStudy(any(UserEntity.class));
            doReturn(Optional.empty()).when(studyEntityRepository).findByInviteCode(any(String.class));

            // when, then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, "000000"))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_INVITE_CODE_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("이미 초대된 사용자면 예외를 던진다")
        void inviteAlreadyExist() {
            // given
            doReturn(4).when(participantEntityRepository).countParticipationStudy(any(UserEntity.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findByInviteCode(any(String.class));

            // when
            알고리즘스터디.invite(장재우);

            // then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, "000000"))
                    .isInstanceOf(InviteAlreadyExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_INVITE_USER.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(4).when(participantEntityRepository).countParticipationStudy(any(UserEntity.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findByInviteCode(any(String.class));
            doReturn(List.of()).when(roundEntityRepository).findFutureRounds(any(StudyEntity.class), any());

            // when
            studyInviteService.inviteUser(장재우, "000000");

            // then
            softly.assertThat(알고리즘스터디.getParticipantList().size()).isEqualTo(2);
            softly.assertThat(알고리즘스터디.getParticipantList().contains(new ParticipantEntity(최규현, 알고리즘스터디)));
            softly.assertThat(알고리즘스터디.getParticipantList().contains(new ParticipantEntity(장재우, 알고리즘스터디)));
        }
    }

    @Nested
    class leaveUser {
        @Test
        @DisplayName("존재하지 않는 스터디이면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyEntityRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> studyInviteService.leaveUser(최규현, -1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyEntityRepository).findById(any(Long.class));
            doReturn(List.of()).when(noticeEntityRepository).findNoticesByStudy(any(StudyEntity.class));

            // when
            알고리즘스터디.invite(장재우);
            studyInviteService.leaveUser(장재우, -1L);

            // then
            assertAll(
                    () -> assertThat(알고리즘스터디.getParticipantList().size()).isEqualTo(1),
                    () -> assertThat(알고리즘스터디.getParticipantList().contains(new ParticipantEntity(장재우, 알고리즘스터디)))
            );
        }
    }


}