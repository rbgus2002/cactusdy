package ssu.groupstudy.domain.user.api;

import org.mockito.BDDMockito;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserService;

import static org.mockito.BDDMockito.given;

@WebMvcTest(UserApi.class) // 모든 Bean 로드해서 오래 걸림
class UserApiTest {
    @Autowired
    private MockMvc mockMvc; // 컨트롤러 테스트를 위한 HTTP 호출 객체

    @MockBean
    private UserService userService;

    @DisplayName("회원 가입")
    @Test
    void 회원가입() throws Exception{
        // given
        SignUpRequest signUpRequest = new SignUpRequest("최규현", "규규", "", "", "rbgus2002@gmail.com");
//        given(userService.signUp(signUpRequest)).willReturn(signUpRequest.toEntity());

        // when

    }
}