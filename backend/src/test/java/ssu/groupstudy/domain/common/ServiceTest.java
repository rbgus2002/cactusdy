package ssu.groupstudy.domain.common;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.dto.CreateRoundRequest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

import java.time.LocalDateTime;

/**
 * 모든 엔티티는 id를 갖으며 영속화 되어있다고 생각한다.
 */
@ExtendWith(MockitoExtension.class)
public class ServiceTest {
    protected SignUpRequest 최규현SignUpRequest;
    protected SignUpRequest 장재우SignUpRequest;
    protected User 최규현;
    protected User 장재우;

    protected CreateStudyRequest 알고리즘스터디CreateRequest;
    protected CreateStudyRequest 영어스터디CreateRequest;
    protected Study 알고리즘스터디;
    protected Study 영어스터디;

    protected CreateNoticeRequest 공지사항1CreateRequest;
    protected Notice 공지사항1;

    protected CreateRoundRequest 라운드1CreateRoundRequest;
    protected CreateRoundRequest 라운드2CreateRoundRequest_EmptyTimeAndPlace;
    protected Round 회차1;
    protected Round 회차2_EmptyTimeAndPlace;

    protected RoundParticipant 회차1_최규현;

    @BeforeEach
    void initDummyData() {
        initSignUpRequest();
        initUser();
        initCreateStudyRequest();
        initStudy();
        initCreateNoticeRequest();
        initNotice();
        initCreateRoundRequest();
        initRound();
        initRoundParticipant();
    }

    private void initSignUpRequest() {
        최규현SignUpRequest = SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
        장재우SignUpRequest = SignUpRequest.builder()
                .name("장재우")
                .email("arkady@naver.com")
                .nickName("킹적화")
                .phoneModel("")
                .picture("")
                .build();
    }

    private void initUser() {
        최규현 = 최규현SignUpRequest.toEntity();
        ReflectionTestUtils.setField(최규현, "userId", 1L);
        장재우 = 장재우SignUpRequest.toEntity();
        ReflectionTestUtils.setField(장재우, "userId", 2L);
    }

    private void initCreateStudyRequest() {
        알고리즘스터디CreateRequest = CreateStudyRequest.builder()
                .studyName("알고리즘")
                .detail("내용1")
                .picture("")
                .hostUserId(-1L)
                .build();
        영어스터디CreateRequest = CreateStudyRequest.builder()
                .studyName("영어")
                .detail("내용2")
                .picture("")
                .hostUserId(-1L)
                .build();
    }

    private void initStudy() {
        알고리즘스터디 = 알고리즘스터디CreateRequest.toEntity(최규현);
        ReflectionTestUtils.setField(알고리즘스터디, "studyId", 3L);
        영어스터디 = 영어스터디CreateRequest.toEntity(최규현);
        ReflectionTestUtils.setField(영어스터디, "studyId", 4L);

    }

    private void initCreateNoticeRequest() {
        공지사항1CreateRequest = CreateNoticeRequest.builder()
                .userId(-1L)
                .studyId(-1L)
                .title("공지사항1")
                .contents("내용1")
                .build();
    }

    private void initNotice() {
        공지사항1 = 공지사항1CreateRequest.toEntity(최규현, 알고리즘스터디);
        ReflectionTestUtils.setField(공지사항1, "noticeId", 5L);
    }

    private void initCreateRoundRequest() {
        라운드1CreateRoundRequest = CreateRoundRequest.builder()
                .studyId(-1L)
                .studyPlace("규현집")
                .studyTime(LocalDateTime.of(2023, 5, 17, 16, 0))
                .build();
        라운드2CreateRoundRequest_EmptyTimeAndPlace = CreateRoundRequest.builder()
                .studyId(-1L)
                .studyPlace("재우집")
                .studyTime(LocalDateTime.of(2024, 5, 17, 16, 0))
                .build();
    }

    private void initRound() {
        회차1 = 라운드1CreateRoundRequest.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차1, "roundId", 15L);
        회차2_EmptyTimeAndPlace = 라운드2CreateRoundRequest_EmptyTimeAndPlace.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차2_EmptyTimeAndPlace, "roundId", 18L);
    }

    private void initRoundParticipant() {
        회차1_최규현 = new RoundParticipant(최규현, 회차1);
    }
}
