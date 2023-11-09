package ssu.groupstudy.domain.study.api;

import com.google.gson.Gson;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.domain.study.service.StudyService;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

@ExtendWith(MockitoExtension.class)
class StudyApiTest {
    @InjectMocks
    private StudyApi studyApi;

    @Mock
    private StudyInviteService studyInviteService;

    @Mock
    private StudyService studyService;

    private MockMvc mockMvc;

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(studyApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new Gson();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .picture("")
                .detail("알고문풀")
                .build();
    }

    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
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
//                    .content(gson.toJson(CreateStudyRequest.builder()
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
//            doReturn(1L).when(studyService).createStudy(any(CreateStudyRequest.class));
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
//            DataResponseDto response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResponseDto.class);
//
//            assertThat(response.getData().get("studyId")).isNotNull();
//        }
//    }
}