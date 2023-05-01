package ssu.groupstudy.domain.study.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.domain.StudyPerUser;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class StudyPerUserRepositoryTest {
    @Autowired
    StudyPerUserRepository studyPerUserRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StudyRepository studyRepository;

    private User getUser() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
    }

    private Study getStudy(User hostUser) {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .hostUserId(hostUser.getUserId())
                .detail("PS")
                .picture("")
                .build().toEntity(hostUser, "", "");
    }

    @DisplayName("사용자별 스터디 정보 등록하기")
    @Test
    void 사용자별스터디정보등록() {
        //given
        final User user = getUser();
        final User hostUser = userRepository.save(user);

        final Study study = getStudy(hostUser);
        final Study savedStudy = studyRepository.save(study);

        final StudyPerUser studyPerUser = StudyPerUser.builder()
                .study(savedStudy)
                .user(hostUser)
                .build();

        //when
        final StudyPerUser savedStudyPerUser = studyPerUserRepository.save(studyPerUser);

        //then
        assertThat(savedStudyPerUser.getId()).isNotNull();
        assertThat(savedStudyPerUser.getColor()).isNotNull();
        assertThat(savedStudyPerUser.getUser()).isEqualTo(user);
        assertThat(savedStudyPerUser.getStudy()).isEqualTo(study);
    }

    @DisplayName("사용자가 이미 스터디에 소속되어 있는지 검사")
    @Test
    void 사용자별스터디중복검사() {
        //given
        final User user = getUser();
        final User hostUser = userRepository.save(user);

        final Study study = getStudy(hostUser);
        final Study savedStudy = studyRepository.save(study);

        final StudyPerUser studyPerUser = StudyPerUser.builder()
                .study(savedStudy)
                .user(hostUser)
                .build();

        //when
        final StudyPerUser savedStudyPerUser = studyPerUserRepository.save(studyPerUser);
        final Boolean existStudyPerUser = studyPerUserRepository.existsByUserAndStudy(user, study);

        //then
        assertThat(existStudyPerUser).isNotNull();
        assertThat(existStudyPerUser).isEqualTo(true);
    }
}