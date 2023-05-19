package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class StudyRepositoryTest {
    @Autowired
    StudyRepository studyRepository;

    @Autowired
    private UserRepository userRepository;

    private Study getStudy(User hostUser) {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser);
    }

    private User getUser() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
    }


    @DisplayName("스터디 생성")
    @Test
    void 스터디생성() {
        // given
        final User hostUser = userRepository.save(getUser());
        final Study study = getStudy(hostUser);

        // when
        final Study savedStudy = studyRepository.save(study);

        // then
        assertThat(savedStudy.getStudyId()).isNotNull();
        assertThat(savedStudy.getStudyName()).isEqualTo("AlgorithmSSU");
        assertThat(savedStudy.getDetail()).isEqualTo("PS");
        assertThat(savedStudy.getParticipants().getHostUser()).isEqualTo(hostUser);
    }

    @DisplayName("studyId로 스터디 가져오기")
    @Test
    void 스터디가져오기() {
        //given
        final User hostUser = userRepository.save(getUser());
        final Study study = getStudy(hostUser);

        //when
        final Study saveStudy = studyRepository.save(study);
        final Optional<Study> studyGotten = studyRepository.findByStudyId(saveStudy.getStudyId());

        //then
        assertThat(studyGotten.get().getStudyId()).isNotNull();
        assertThat(studyGotten.get().getStudyName()).isEqualTo("AlgorithmSSU");
        assertThat(studyGotten.get().getDetail()).isEqualTo("PS");
    }
}