package ssu.groupstudy.domain.user.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;

@CustomRepositoryTest
class UserRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserRepository userRepository;
}