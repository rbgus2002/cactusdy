package ssu.groupstudy.domain.user.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;

@CustomRepositoryTest
class UserRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private UserRepository userRepository;

    @Test
    @DisplayName("이메일로 사용자 존재 여부를 검사한다")
    void existsByEmail(){
        // given
        final String 최규현_email = "rbgus2002@naver.com";

        // when
        boolean exist = userRepository.existsByPhoneNumber(최규현_email);

        // then
        softly.assertThat(exist).isTrue();
    }
}