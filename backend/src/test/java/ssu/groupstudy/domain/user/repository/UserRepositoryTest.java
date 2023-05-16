package ssu.groupstudy.domain.user.repository;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class UserRepositoryTest {
    @Autowired
    private UserRepository userRepository;

    private User getUser() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build().toEntity();
    }

    @DisplayName("사용자 등록")
    @Test
    void 사용자등록(){
        // given
        final User user = getUser();

        // when
        final User userSaved = userRepository.save(user);

        // then
        assertThat(userSaved.getUserId()).isNotNull();
        assertThat(userSaved.getName()).isEqualTo("최규현");
        assertThat(userSaved.getEmail()).isEqualTo("rbgus200@@naver.com");
    }

    @DisplayName("이메일 존재 여부 검사")
    @Test
    void 이메일중복검사(){
        // given
        final User user = getUser();

        //when
        userRepository.save(user);
        final Boolean existsUser = userRepository.existsByEmail("rbgus200@@naver.com");

        //then
        assertThat(existsUser).isNotNull();
        assertThat(existsUser).isEqualTo(true);
    }

    @DisplayName("userId로 사용자 가져오기")
    @Test
    void 사용자가져오기(){
        //given
        final User user = getUser();

        //when
        final User savedUser = userRepository.save(user);
        final Optional<User> userGotten = userRepository.findByUserId(savedUser.getUserId());

        //then
        assertThat(userGotten.get().getUserId()).isNotNull();
        assertThat(userGotten.get().getName()).isEqualTo("최규현");
        assertThat(userGotten.get().getEmail()).isEqualTo("rbgus200@@naver.com");
    }
}