package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.context.ApplicationEventPublisher;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.CanNotCreateStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.constant.ResultCode;

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
    private StudyRepository studyRepository;
    @Mock
    private RoundRepository roundRepository;
    @Mock
    private ParticipantRepository participantRepository;
    @Mock
    private RoundParticipantRepository roundParticipantRepository;
    @Mock
    private NoticeRepository noticeRepository;
    @Mock
    private ApplicationEventPublisher eventPublisher;

    @Nested
    class inviteUser {
        @Test
        @DisplayName("참여 중인 스터디가 5개 이상이면 예외를 던진다")
        void canNotCreateStudy(){
            // given
            // when
            doReturn(5).when(participantRepository).countParticipationStudy(any(User.class));

            // then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, "000000"))
                    .isInstanceOf(CanNotCreateStudyException.class)
                    .hasMessage(ResultCode.USER_CAN_NOT_CREATE_STUDY.getMessage());
        }

        @Test
        @DisplayName("스터디가 존재하지 않으면 예외를 던진다")
        void studyNotFound() {
            // given
            doReturn(4).when(participantRepository).countParticipationStudy(any(User.class));
            doReturn(Optional.empty()).when(studyRepository).findByInviteCode(any(String.class));

            // when, then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, "000000"))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_INVITE_CODE_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("이미 초대된 사용자면 예외를 던진다")
        void inviteAlreadyExist() {
            // given
            doReturn(4).when(participantRepository).countParticipationStudy(any(User.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByInviteCode(any(String.class));

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
            doReturn(4).when(participantRepository).countParticipationStudy(any(User.class));
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findByInviteCode(any(String.class));
            doReturn(List.of()).when(roundRepository).findFutureRounds(any(Study.class), any());

            // when
            studyInviteService.inviteUser(장재우, "000000");

            // then
            softly.assertThat(알고리즘스터디.getParticipants().size()).isEqualTo(2);
            softly.assertThat(알고리즘스터디.getParticipants().contains(new Participant(최규현, 알고리즘스터디)));
            softly.assertThat(알고리즘스터디.getParticipants().contains(new Participant(장재우, 알고리즘스터디)));
        }
    }

    @Nested
    class leaveUser {
        @Test
        @DisplayName("존재하지 않는 스터디이면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> studyInviteService.leaveUser(최규현, -1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));
            doReturn(List.of()).when(noticeRepository).findNoticesByStudy(any(Study.class));

            // when
            알고리즘스터디.invite(장재우);
            studyInviteService.leaveUser(장재우, -1L);

            // then
            assertAll(
                    () -> assertThat(알고리즘스터디.getParticipants().size()).isEqualTo(1),
                    () -> assertThat(알고리즘스터디.getParticipants().contains(new Participant(장재우, 알고리즘스터디)))
            );
        }
    }


}