package ssu.groupstudy.domain.rule.api;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.api.rule.controller.RuleController;
import ssu.groupstudy.api.rule.vo.CreateRuleReqVo;
import ssu.groupstudy.domain.rule.service.RuleService;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

@ExtendWith(MockitoExtension.class)
class RuleControllerTest {
    @InjectMocks
    private RuleController ruleController;

    @Mock
    private RuleService ruleService;

    private MockMvc mockMvc; // 컨트롤러 테스트를 위한 HTTP 호출 객체

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(ruleController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new Gson();
    }

    private CreateRuleReqVo getCreateRuleRequest() {
        return CreateRuleReqVo.builder()
                .studyId(-1L)
                .detail("숙제안해오면강퇴")
                .build();
    }

    private CreateStudyReqVo getRegisterStudyRequest() {
        return CreateStudyReqVo.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .color("0x00")
                .build();
    }

//    private StudyEntity getStudy() {
//        return getRegisterStudyRequest().toEntity(getUser());
//    }


    private SignUpReqVo getSignUpRequest() {
        return SignUpReqVo.builder()
                .name("최규현")
                .phoneNumber("rbgus200@@naver.com")
                .nickname("규규")
                .build();
    }

//    private UserEntity getUser() {
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
//                    .content(gson.toJson(CreateRuleReqVo.builder()
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
//            doThrow(new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND)).when(ruleService).createRule(any(CreateRuleReqVo.class));
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