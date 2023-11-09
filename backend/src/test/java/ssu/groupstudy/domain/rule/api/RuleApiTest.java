package ssu.groupstudy.domain.rule.api;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.rule.dto.request.CreateRuleRequest;
import ssu.groupstudy.domain.rule.service.RuleService;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

@ExtendWith(MockitoExtension.class)
class RuleApiTest {
    @InjectMocks
    private RuleApi ruleApi;

    @Mock
    private RuleService ruleService;

    private MockMvc mockMvc; // 컨트롤러 테스트를 위한 HTTP 호출 객체

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(ruleApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new Gson();
    }

    private CreateRuleRequest getCreateRuleRequest() {
        return CreateRuleRequest.builder()
                .studyId(-1L)
                .detail("숙제안해오면강퇴")
                .build();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .picture("")
                .detail("알고문풀")
                .build();
    }

//    private Study getStudy() {
//        return getRegisterStudyRequest().toEntity(getUser());
//    }


    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .phoneNumber("rbgus200@@naver.com")
                .nickname("규규")
                .build();
    }

//    private User getUser() {
//        return getSignUpRequest().toEntity();
//    }


//    @Nested
//    class 규칙생성{
//        @Test
//        @DisplayName("내용이 없는 규칙을 생성할 경우 예외를 던진다")
//        void 실패_규칙내용존재X() throws Exception {
//            // given
//            final String url = "/rule";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateRuleRequest.builder()
//                            .studyId(-1L)
//                            .detail("")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }
//
//        @Test
//        @DisplayName("존재하지 않는 스터디에 규칙을 생성하면 예외를 던진다")
//        void 실패_스터디존재X() throws Exception {
//            // given
//            final String url = "/rule";
//            doThrow(new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND)).when(ruleService).createRule(any(CreateRuleRequest.class));
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(getCreateRuleRequest()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isNotFound());
//        }
//
//        @Test
//        @DisplayName("성공")
//        void 성공() throws Exception {
//            // given
//            final String url = "/rule";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(getCreateRuleRequest()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isOk());
//
//            ResponseDto response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResponseDto.class);
//
//            assertThat(response.getMessage()).isEqualTo(ResultCode.OK.getMessage());
//        }
//    }

}