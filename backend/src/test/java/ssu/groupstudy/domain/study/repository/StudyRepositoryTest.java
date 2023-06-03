package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.common.RepositoryTest;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.exception.CanNotLeaveStudyException;
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


class StudyRepositoryTest extends RepositoryTest {
    @DisplayName("새로운 스터디를 생성한다")
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

    @DisplayName("studyId로 스터디를 가져온다")
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

    @DisplayName("스터디 생성 시에 participants가 영속화되는지 확인한다")
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
}