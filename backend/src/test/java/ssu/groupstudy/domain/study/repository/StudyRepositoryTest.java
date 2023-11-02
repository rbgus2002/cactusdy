package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.study.domain.Study;

import java.util.Optional;


@CustomRepositoryTest
class StudyRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private StudyRepository studyRepository;

    @Test
    @DisplayName("삭제된 스터디는 가져오지 않는다")
    void findById(){
        // given
        Study study = studyRepository.findById(1L).get();
        study.delete();

        // when
        Optional<Study> deletedStudy = studyRepository.findById(1L);

        // then
        softly.assertThat(deletedStudy).isEmpty();
    }
}