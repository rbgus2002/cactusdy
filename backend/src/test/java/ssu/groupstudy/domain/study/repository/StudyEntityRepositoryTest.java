package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.dto.DoneCount;
import ssu.groupstudy.domain.study.dto.StatusTagInfo;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.List;
import java.util.Optional;


@CustomRepositoryTest
class StudyEntityRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private StudyEntityRepository studyEntityRepository;
    @Autowired
    private UserEntityRepository userEntityRepository;

    @Test
    @DisplayName("삭제된 스터디는 가져오지 않는다")
    void findById(){
        // given
        StudyEntity study = studyEntityRepository.findById(1L).get();
        study.delete();

        // when
        Optional<StudyEntity> deletedStudy = studyEntityRepository.findById(1L);

        // then
        softly.assertThat(deletedStudy).isEmpty();
    }

    @Test
    @DisplayName("각 출석태그의 횟수를 모두 가져온다")
    void calculateStatusTag(){
        // given
        UserEntity user = userEntityRepository.findById(1L).get();
        StudyEntity study = studyEntityRepository.findById(1L).get();

        // when
        List<StatusTagInfo> statusTagInfos = studyEntityRepository.calculateStatusTag(user, study);

        // then
        softly.assertThat(statusTagInfos).isNotEmpty();
    }

    @Test
    @DisplayName("본인의 모든 과제 수를 가져온다")
    void calculateDoneCount(){
        // given
        UserEntity user = userEntityRepository.findById(1L).get();
        StudyEntity study = studyEntityRepository.findById(1L).get();

        // when
        DoneCount doneCount = studyEntityRepository.calculateDoneCount(user, study);

        // then
        softly.assertThat(doneCount.getSumCount()).isGreaterThan(0);
    }
}