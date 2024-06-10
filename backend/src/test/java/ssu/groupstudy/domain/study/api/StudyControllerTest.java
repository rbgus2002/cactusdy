package ssu.groupstudy.domain.study.api;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.api.study.controller.StudyController;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.domain.common.handler.GlobalExceptionHandler;

@ExtendWith(MockitoExtension.class)
class StudyControllerTest {
    @InjectMocks
    private StudyController studyController;

    @Mock
    private StudyInviteService studyInviteService;

    @Mock
    private StudyService studyService;

    private MockMvc mockMvc;

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(studyController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new Gson();
    }

    private CreateStudyReqVo getRegisterStudyRequest() {
        return CreateStudyReqVo.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .color("0x00")
                .build();
    }

    private SignUpReqVo getSignUpRequest() {
        return SignUpReqVo.builder()
                .name("최규현")
                .phoneNumber("rbgus2002@naver.com")
                .nickname("규규")
                .build();
    }

//    @Nested
//    class 스터디생성 {
//        @Test
//        @DisplayName("스터디 생성 시 반드시 스터디의 이름을 반드시 정해주어야 한다")
//        void 실패_이름존재X() throws Exception {
//            // given
//            final String url = "/study";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateStudyReqVo.builder()
//                            .studyName("")
//                            .hostUserId(-1L)
//                            .picture("")
//                            .detail("알고문풀")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }

//        @Test
//        @DisplayName("성공")
//        void 성공() throws Exception {
//            // given
//            final String url = "/study";
//
//            doReturn(1L).when(studyService).createStudy(any(CreateStudyReqVo.class));
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(getRegisterStudyRequest()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isOk());
//
//            DataResVo response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResVo.class);
//
//            assertThat(response.getData().get("studyId")).isNotNull();
//        }
//    }
}