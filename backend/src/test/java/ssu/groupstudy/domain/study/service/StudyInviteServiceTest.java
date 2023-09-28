package ssu.groupstudy.domain.study.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

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
    private UserRepository userRepository;

    @Mock
    private StudyRepository studyRepository;

    @Nested
    class inviteUser {
        @Test
        @DisplayName("존재하지 않는 스터디이면 예외를 던진다")
        void fail_studyNotFound() {
            // given
            doReturn(Optional.empty()).when(studyRepository).findById(any(Long.class));

            // when, then
            assertThatThrownBy(() -> studyInviteService.inviteUser(null, -1L))
                    .isInstanceOf(StudyNotFoundException.class)
                    .hasMessage(ResultCode.STUDY_NOT_FOUND.getMessage());
        }

        @Test
        @DisplayName("이미 초대된 사용자면 예외를 던진다")
        void inviteAlreadyExist() {
            // given
            // when
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));

            // then
            assertThatThrownBy(() -> studyInviteService.inviteUser(최규현, -1L))
                    .isInstanceOf(InviteAlreadyExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_INVITE_USER.getMessage());
        }

        @Test
        @DisplayName("성공")
        void 성공() {
            // given
            doReturn(Optional.of(알고리즘스터디)).when(studyRepository).findById(any(Long.class));

            // when
            studyInviteService.inviteUser(null, -1L);

            // then
            assertAll(
                    () -> assertThat(알고리즘스터디.getParticipants().size()).isEqualTo(2),
                    () -> assertThat(알고리즘스터디.getParticipants().contains(new Participant(장재우, 알고리즘스터디)))
            );
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