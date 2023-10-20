package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CustomRepositoryTest
class ParticipantRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private ParticipantRepository participantRepository;

    @DisplayName("스터디에 소속되어있는 사용자인지 확인한다")
    @Test
    void isParticipated() {
        // given
        User 최규현 = userRepository.findById(1L).get();
        Study 스터디 = studyRepository.findById(1L).get();
        스터디.invite(최규현);

        // when
        boolean isParticipated = 스터디.isParticipated(최규현);

        // then
        softly.assertThat(isParticipated).isTrue();
    }

    @Nested
    class invite {
        @DisplayName("이미 참여중인 사용자를 스터디에 초대하면 예외를 던진다")
        @Test
        void userAlreadyExist() {
            // given
            User 최규현 = userRepository.findById(1L).get();
            Study 스터디 = studyRepository.findById(1L).get();
            스터디.invite(최규현);

            // when, then
            softly.assertThatThrownBy(() -> 스터디.invite(최규현))
                    .isInstanceOf(InviteAlreadyExistsException.class)
                    .hasMessage(ResultCode.DUPLICATE_INVITE_USER.getMessage());
        }

        @DisplayName("새로운 사용자를 스터디에 초대한다")
        @Test
        void success() {
            // given
            User 최규현 = userRepository.findById(1L).get();
            Study 스터디 = studyRepository.findById(1L).get();
            스터디.invite(최규현);

            // when
            Optional<Participant> 최규현_스터디 = participantRepository.findByUserAndStudy(최규현, 스터디);

            // then
            softly.assertThat(최규현_스터디).isNotEmpty();
        }
    }

    @Nested
    class leave {
        @DisplayName("참여중이지 않은 사용자가 스터디 탈퇴를 시도하면 예외를 던진다")
        @Test
        void fail_userNotFound() {
            // given
            User 장재우 = userRepository.findById(2L).get();
            Study 스터디 = studyRepository.findById(1L).get();


            // when, then
            softly.assertThatThrownBy(() -> 스터디.leave(장재우))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(ResultCode.USER_NOT_PARTICIPATED.getMessage());
        }

        @DisplayName("방장은 스터디에 탈퇴할 수 없다")
        @Test
        void fail_hostUserInvalid() {
            // given, then
            User 최규현 = userRepository.findById(1L).get();
            Study 스터디 = studyRepository.findById(1L).get();
            스터디.invite(최규현);

            // when
            softly.assertThatThrownBy(() -> 스터디.leave(최규현))
                    .isInstanceOf(CanNotLeaveStudyException.class)
                    .hasMessage(ResultCode.HOST_USER_CAN_NOT_LEAVE_STUDY.getMessage());
        }

        @DisplayName("사용자가 스터디에서 탈퇴한다")
        @Test
        void success() {
            // given
            User 장재우 = userRepository.findById(2L).get();
            Study 스터디 = studyRepository.findById(1L).get();
            스터디.invite(장재우);

            // when
            스터디.leave(장재우);
            boolean isParticipated = 스터디.isParticipated(장재우);

            // then
            softly.assertThat(isParticipated).isFalse();
        }
    }

    @Test
    @DisplayName("스터디에 소속된 사용자를 초대순서로 정렬해서 모두 불러온다")
    void getParticipantsOrderByCreateDateAsc() {
        // given
        User 최규현 = userRepository.findById(1L).get();
        User 장재우 = userRepository.findById(2L).get();
        Study 스터디 = studyRepository.findById(1L).get();
        participantRepository.save(Participant.builder()
                .user(최규현)
                .study(스터디)
                .build());
        participantRepository.save(Participant.builder()
                .user(장재우)
                .study(스터디)
                .build());

        // when
        List<Participant> participants = 스터디.getParticipants().stream()
                .sorted(Comparator.comparing(Participant::getCreateDate))
                .collect(Collectors.toList());

        // then
        softly.assertThat(participants.size()).isEqualTo(2);
        softly.assertThat(participants.get(0).getCreateDate()).isBefore(participants.get(1).getCreateDate());
    }
}