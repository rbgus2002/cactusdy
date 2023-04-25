package ssu.groupstudy.domain.user.api;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserService;

@WebMvcTest(UserApi.class)
class UserApiTest {

    @MockBean
    private UserService userService;

    @Autowired
    private MockMvc mockMvc; // 컨트롤러 테스트를 위한 HTTP 호출 객체

    @DisplayName("회원 가입 성공")
    @Test
    void 회원가입_성공() throws Exception{
        // given
        SignUpRequest signUpRequest = new SignUpRequest("최규현", "규규", "", "", "rbgus2002@gmail.com");

        // TODO : 컨트롤러 단위 테스트
    }
}