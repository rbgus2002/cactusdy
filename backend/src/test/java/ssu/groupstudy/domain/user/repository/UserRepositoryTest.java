package ssu.groupstudy.domain.user.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import ssu.groupstudy.domain.user.domain.User;
import org.assertj.core.api.Assertions;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class UserRepositoryTest {
    @Autowired
    private UserRepository userRepository;

    @DisplayName("사용자 추가")
    @Test
    void 사용자추가(){
        // given
        User user = new SignUpRequest("최규현", "규규", "", "", "rbgus200@@naver.com").toEntity();

        // when
        User userSaved = userRepository.save(user);

        // then
        Assertions.assertThat(userSaved.getProfile().getName()).isEqualTo(user.getProfile().getName());
        Assertions.assertThat(userSaved.getProfile().getNickName()).isEqualTo(user.getProfile().getNickName());
        Assertions.assertThat(userSaved.getPhoneModel()).isEqualTo(user.getPhoneModel());
        Assertions.assertThat(userSaved.getUserId()).isNotNull();
    }
}