package ssu.groupstudy.domain.round.api;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import ssu.groupstudy.domain.notice.api.NoticeApi;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.service.NoticeService;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
import ssu.groupstudy.domain.round.service.RoundService;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class RoundApiTest {
    @InjectMocks
    private RoundApi roundApi;

    @Mock
    private RoundService roundService;

    private MockMvc mockMvc;

    private Gson gson;

    @BeforeEach
    public void init() {
        mockMvc = MockMvcBuilders.standaloneSetup(roundApi)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm")
                .create();
    }

    private CreateRoundRequest getCreateRoundRequest() {
        return CreateRoundRequest.builder()
                .studyId(-1L)
                .studyPlace("규현집")
                .studyTime(LocalDateTime.of(2023, 5, 17, 16, 00))
                .build();
    }

    private CreateStudyRequest getRegisterStudyRequest() {
        return CreateStudyRequest.builder()
                .studyName("AlgorithmSSU")
                .detail("알고문풀")
                .picture("")
                .hostUserId(0L)
                .build();
    }

    private SignUpRequest getSignUpRequest() {
        return SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
    }

    private User getUser() {
        return getSignUpRequest().toEntity();
    }

    private Study getStudy() {
        return getRegisterStudyRequest().toEntity(getUser(), "", "");
    }


    // TODO : Gson을 통해 LocalDateTime을 Json으로 만들기 위해선 따로 TypeAdapter 생성해주어야 함
    @Nested
    class 회차생성 {
//        @Test
//        @DisplayName("회차 생성 시에 studyId가 비어있는 경우 예외를 던진다")
//        void 실패_studyId존재X() throws Exception {
//            // given
//            final String url = "/round";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateRoundRequest.builder()
//                            .studyPlace("규현집")
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }
//
////        @Test
////        @DisplayName("회차 생성 시에 studyTime 인자의 format은 '2023-05-16 16:50' 와 같이 지정한다")
////        void 실패_studyTime_형식에러() throws Exception {
////            // given
////            final String url = "/round";
////
////            // when
////            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
////            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
////                    .content(gson.toJson(CreateRoundRequest.builder()
////                            .studyTime(LocalDateTime.parse("2023-05-17 16:00", formatter))
////                            .studyId(-1L)
////                            .build()))
////                    .contentType(MediaType.APPLICATION_JSON)
////            );
////
////            // then
////            resultActions.andExpect(status().isBadRequest());
////        }
//
//        @Test
//        @DisplayName("성공")
//        void 성공() throws Exception {
//            // given
//            final String url = "/round";
//            doReturn(getCreateRoundRequest().toEntity(getStudy())).when(roundService).createRound(any(CreateRoundRequest.class));
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateRoundRequest.builder()
//                            .studyPlace("규현집")
//                            .build()))
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
//            assertThat(response.getData().get("notice")).isNotNull();
//        }
    }
}