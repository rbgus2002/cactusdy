package ssu.groupstudy.domain.notice.api;

import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.common.ApiTest;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.domain.study.dto.request.CreateStudyRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

class NoticeApiTest extends ApiTest {
    @InjectMocks
    private NoticeApi noticeApi;

    @Mock
    private NoticeService noticeService;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(noticeApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .color("0x00")
                .build();
    }

//    private StudyEntity getStudy() {
//        return getRegisterStudyRequest().toEntity(getUser());
//    }


    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .phoneNumber("rbgus200@@naver.com")
                .nickname("규규")
                .build();
    }

//    private UserEntity getUser() {
//        return getSignUpRequest().toEntity();
//    }

    private CreateNoticeRequest getCreateNoticeRequest(){
        return CreateNoticeRequest.builder()
                .studyId(1L)
                .title("notice")
                .contents("contents")
                .build();
    }

//    @Nested
//    class 공지사항생성{
//        @Test
//        @DisplayName("빈 제목의 공지사항을 생성하는 경우 예외를 던진다")
//        void 실패_비어있는제목() throws Exception {
//            // given
//            final String url = "/notice";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateNoticeRequest.builder()
//                            .userId(1L)
//                            .studyId(1L)
//                            .title("")
//                            .contents("contents")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }
//
//        @Test
//        @DisplayName("성공")
//        void 성공() throws Exception {
//            // given
//            final String url = "/notice";
//            Notice notice = getCreateNoticeRequest().toEntity(getUser(), getStudy());
//            doReturn(notice).when(noticeService).createNotice(any(CreateNoticeRequest.class));
//            ReflectionTestUtils.setField(notice, "noticeId", 1L);
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(getCreateNoticeRequest()))
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