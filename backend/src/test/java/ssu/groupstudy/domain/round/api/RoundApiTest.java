package ssu.groupstudy.domain.round.api;

import com.google.gson.Gson;
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
import ssu.groupstudy.global.handler.GlobalExceptionHandler;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
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
        gson = new Gson();
    }

    @Nested
    class 회차생성 {
        @Test
        @DisplayName("회차 생성 시에 studyId가 비어있는 경우 예외를 던진다")
        void 실패_studyId존재X() throws Exception {
            // given
            final String url = "/round";

            // when
            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
                    .content(gson.toJson(CreateRoundRequest.builder()
                            .studyPlace("규현집")
                            .build()))
                    .contentType(MediaType.APPLICATION_JSON)
            );

            // then
            resultActions.andExpect(status().isBadRequest());
        }

//        @Test
//        @DisplayName("회차 생성 시에 studyTime 인자의 format은 2023-05-16 16:50 와 같이 지정한다")
//        void 실패_studyTime_형식에러() throws Exception {
//            // given
//            final String url = "/round";
//
//            // when
//            final ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders.post(url)
//                    .content(gson.toJson(CreateRoundRequest.builder()
//                            .studyTime(LocalDateTime.now())
//                            .studyId(-1L)
//                            .build()))
//                    .contentType(MediaType.APPLICATION_JSON)
//            );
//
//            // then
//            resultActions.andExpect(status().isBadRequest());
//        }

    }
}