package ssu.groupstudy.domain.notice.api;

import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.api.notice.controller.NoticeController;
import ssu.groupstudy.domain.common.ApiTest;
import ssu.groupstudy.api.notice.vo.CreateNoticeReqVo;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

class NoticeControllerTest extends ApiTest {
    @InjectMocks
    private NoticeController noticeController;

    @Mock
    private NoticeService noticeService;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(noticeController)
                .setControllerAdvice(new GlobalExceptionHandler())
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

    private CreateNoticeReqVo getCreateNoticeRequest(){
        return CreateNoticeReqVo.builder()
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
//                    .content(gson.toJson(CreateNoticeReqVo.builder()
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
//            NoticeEntity notice = getCreateNoticeRequest().toEntity(getUser(), getStudy());
//            doReturn(notice).when(noticeService).createNotice(any(CreateNoticeReqVo.class));
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
//            ResVo response = gson.fromJson(resultActions.andReturn()
//                    .getResponse()
//                    .getContentAsString(StandardCharsets.UTF_8), DataResVo.class);
//
//            assertThat(response.getMessage()).isEqualTo(ResultCode.OK.getMessage());
//        }
//    }
}