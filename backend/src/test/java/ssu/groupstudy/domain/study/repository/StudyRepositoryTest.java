package ssu.groupstudy.domain.study.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.user.repository.UserRepository;


@CustomRepositoryTest
class StudyRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private StudyRepository studyRepository;
    @Autowired
    private UserRepository userRepository;

}