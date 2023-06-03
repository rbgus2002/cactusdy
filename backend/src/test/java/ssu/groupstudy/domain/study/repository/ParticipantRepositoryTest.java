package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.study.domain.Participants;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

class ParticipantRepositoryTest extends RepositoryTest {
    @DisplayName("스터디에 소속되어있는 사용자인지 확인한다")
    @Test
    void isParticipated() {
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);

        // when
        boolean isParticipated = 알고리즘스터디.isParticipated(최규현);

        // then
        assertThat(isParticipated).isTrue();
    }

    @Nested
    class invite {
        @DisplayName("이미 참여중인 사용자를 스터디에 초대하면 예외를 던진다")
        @Test
        void fail_alreadyExistUser() {
            // given
            userRepository.save(최규현);
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);

            // when, then
            assertThatThrownBy(() -> 알고리즘스터디.invite(최규현))
                    .isInstanceOf(InviteAlreadyExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_INVITE_USER.getMessage());
        }

        @DisplayName("새로운 사용자를 스터디에 초대한다")
        @Test
        void success() {
            // given
            Long userId = userRepository.save(최규현).getUserId();
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);

            // when
            알고리즘스터디.invite(장재우);
            Participant participant = participantRepository.findParticipantByUserAndStudy(장재우, 알고리즘스터디).get();

            // then
            assertAll(
                    () -> assertThat(알고리즘스터디.getParticipants().getParticipants().size()).isEqualTo(2),
                    () -> assertThat(알고리즘스터디.isParticipated(장재우)),
                    () -> assertThat(participant.getUser()).isEqualTo(장재우)
            );
        }
    }

    @Nested
    class leave {
        @DisplayName("참여중이지 않은 사용자가 스터디 탈퇴를 시도하면 예외를 던진다")
        @Test
        void fail_userNotFound() {
            // given
            userRepository.save(최규현);
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);

            // when, then
            assertThatThrownBy(() -> 알고리즘스터디.leave(장재우))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(ResultCode.USER_NOT_PARTICIPATED.getMessage());
        }

        @DisplayName("방장은 스터디에 탈퇴할 수 없다")
        @Test
        void fail_hostUserInvalid() {
            // given
            userRepository.save(최규현);
            studyRepository.save(알고리즘스터디);

            // when, then
            assertThatThrownBy(() -> 알고리즘스터디.leave(최규현))
                    .isInstanceOf(CanNotLeaveStudyException.class)
                    .hasMessage(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY.getMessage());
        }

        @DisplayName("사용자가 스터디에서 탈퇴한다")
        @Test
        void success() {
            // given
            userRepository.save(최규현).getUserId();
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);

            // when
            알고리즘스터디.invite(장재우);
            알고리즘스터디.leave(장재우);

            // then
            assertThat(알고리즘스터디.getParticipants().getParticipants().size()).isEqualTo(1);
        }
    }
}