package ssu.groupstudy.domain.user.api;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.BDDMockito;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.doThrow;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class UserApiTest {
    @InjectMocks
    private UserApi userApi;

    @Mock
    private UserService userService;

    private MockMvc mockMvc; // 컨트롤러 테스트를 위한 HTTP 호출 객체

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(userApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new Gson();
    }

    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus2002@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
    }

    @Test
    @DisplayName("회원가입_실패_이메일형식X")
    void 회원가입_실패_이메일형식X() throws Exception {
        // given
        final String url = "/user/register";

        // when
        final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
                .content(gson.toJson(SignUpRequest.builder()
                        .name("최규현")
                        .email("rbgus2002")
                        .nickName("규규")
                        .phoneModel("")
                        .picture("")
                        .build()))
                .contentType(MediaType.APPLICATION_JSON)
        );

        // then
        resultActions.andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("")
    void 회원가입_실패_이메일중복존재() throws Exception {
        // given
        final String url = "/user/register";
        doThrow(new EmailExistsException(ResultCode.DUPLICATE_EMAIL)).when(userService).signUp(any(SignUpRequest.class));

        // when
        final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
                        .content(gson.toJson(getSignUpRequest()))
                        .contentType(MediaType.APPLICATION_JSON)
        );

        // then
        resultActions.andExpect(status().isBadRequest());
    }

    @DisplayName("회원가입_성공")
    @Test
    void 회원가입_성공() throws Exception {
        // given
        final String url = "/user/register";
        doReturn(getSignUpRequest().toEntity()).when(userService).signUp(any(SignUpRequest.class));

        // when
        final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
                .content(gson.toJson(getSignUpRequest()))
                .contentType(MediaType.APPLICATION_JSON)
        );

        // then
        resultActions.andExpect(status().isOk());


    }
}