package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.InviteAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertAll;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class StudyRepositoryTest {
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ParticipantRepository participantRepository;

    private User 최규현;
    private User 장재우;
    private User 홍예지;
    private Study 알고리즘스터디;

    @BeforeEach
    void init() {
        최규현 = new SignUpRequest("최규현", "규규", "rbgus2002@naver.com").toEntity();
        장재우 = new SignUpRequest("장재우", "킹적화", "arkady@naver.com").toEntity();
        홍예지 = new SignUpRequest("홍예지", "찡찡이", "are_you_hungry@question.com").toEntity();
        알고리즘스터디 = new CreateStudyRequest("알고리즘스터디", "화이팅", "", -1L).toEntity(최규현);
    }

    @DisplayName("새로운 스터디를 생성한다.")
    @Test
    void createStudy() {
        // given
        userRepository.save(최규현);

        // when
        studyRepository.save(알고리즘스터디);

        // then
        assertAll(
                () -> assertThat(알고리즘스터디.getStudyId()).isNotNull(),
                () -> assertThat(알고리즘스터디.getStudyName()).isEqualTo("알고리즘스터디"),
                () -> assertThat(알고리즘스터디.getDetail()).isEqualTo("화이팅"),
                () -> assertThat(알고리즘스터디.getParticipants().getParticipants().size()).isEqualTo(1),
                () -> assertThat(알고리즘스터디.getParticipants().getHostUser()).isEqualTo(최규현)
        );
    }

    @DisplayName("studyId로 스터디를 가져온다.")
    @Test
    void findStudy() {
        //given
        userRepository.save(최규현);

        //when
        Long 알고리즘스터디id = studyRepository.save(알고리즘스터디).getStudyId();
        final Optional<Study> study = studyRepository.findByStudyId(알고리즘스터디id);

        //then
        assertAll(
                () -> assertThat(study).isNotEmpty(),
                () -> assertThat(study.get()).isEqualTo(알고리즘스터디)
        );
    }

    @DisplayName("스터디 생성 시에 Participants가 영속화되는지 확인한다.")
    @Test
    void findParticipant() {
        // given
        userRepository.save(최규현);
        studyRepository.save(알고리즘스터디);

        // when
        Set<Participant> participants = 알고리즘스터디.getParticipants().getParticipants();

        // then
        for (Participant participant : participants) {
            assertThat(participant.getId()).isNotNull();
        }
    }

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
        @DisplayName("이미 참여중인 사용자를 스터디에 초대하면 예외를 던진다.")
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

        @DisplayName("새로운 사용자를 스터디에 초대한다.")
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
    class exit {
        @DisplayName("참여중이지 않은 사용자가 스터디를 탈퇴하면 예외를 던진다.")
        @Test
        void fail_userNotFound() {
            // given
            userRepository.save(최규현);
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);
            
            // when, then
            assertThatThrownBy(() -> 알고리즘스터디.exit(장재우))
                    .isInstanceOf(UserNotParticipatedException.class)
                    .hasMessage(ResultCode.USER_NOT_PARTICIPATED.getMessage());
        }

        @DisplayName("사용자가 스터디에서 탈퇴한다.")
        @Test
        void success() {
            // given
            userRepository.save(최규현).getUserId();
            userRepository.save(장재우);
            studyRepository.save(알고리즘스터디);
            알고리즘스터디.invite(장재우);

            // when
            알고리즘스터디.exit(장재우);

            // then
            assertThat(알고리즘스터디.getParticipants().getParticipants().size()).isEqualTo(1);
        }
    }
}