package ssu.groupstudy.domain.common;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.assertj.core.api.junit.jupiter.SoftAssertionsExtension;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.study.domain.Participant;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

import java.time.LocalDateTime;

/**
 * 모든 엔티티는 id를 갖으며 영속화 되어있다고 생각한다.
 */
@ExtendWith(MockitoExtension.class)
@ExtendWith(SoftAssertionsExtension.class)
public class ServiceTest {
    @InjectSoftAssertions
    protected SoftAssertions softly;
    protected SignUpRequest 최규현SignUpRequest;
    protected SignUpRequest 장재우SignUpRequest;
    protected User 최규현;
    protected User 장재우;

    protected CreateStudyRequest 알고리즘스터디CreateRequest;
    protected CreateStudyRequest 영어스터디CreateRequest;
    protected Study 알고리즘스터디;
    protected Study 영어스터디;

    protected Participant 스터디참여자_최규현;

    protected CreateNoticeRequest 공지사항1CreateRequest;
    protected Notice 공지사항1;
    protected Notice 공지사항2;
    protected Notice 공지사항3;
    protected Notice 공지사항4;

    protected CreateCommentRequest 댓글1CreateRequest;
    protected CreateCommentRequest 댓글2CreateRequest;
    protected CreateCommentRequest 대댓글1CreateRequest;
    protected Comment 댓글1;
    protected Comment 댓글2;
    protected Comment 대댓글1;

    protected AppointmentRequest 회차1AppointmentRequest;
    protected AppointmentRequest 회차2AppointmentRequest_EmptyTimeAndPlace;
    protected Round 회차1;
    protected Round 회차2_EmptyTimeAndPlace;

    protected RoundParticipant 회차1_최규현;
    protected RoundParticipant 회차1_장재우;

    protected Task 그룹태스크;
    protected Task 개인태스크;

    @BeforeEach
    void initDummyData() {
        initSignUpRequest();
        initUser();
        initCreateStudyRequest();
        initStudy();
        initParticipant();
        initCreateNoticeRequest();
        initNotice();
        initCreateCommentRequest();
        initComment();
        initCreateRoundRequest();
        initRound();
        initRoundParticipant();
        initTask();
    }

    private void initSignUpRequest() {
        최규현SignUpRequest = SignUpRequest.builder()
                .name("최규현")
                .phoneNumber("rbgus200@naver.com")
                .password("valid")
                .nickname("규규")
                .build();
        장재우SignUpRequest = SignUpRequest.builder()
                .name("장재우")
                .phoneNumber("arkady@naver.com")
                .password("password")
                .nickname("킹적화")
                .build();
    }

    private void initUser() {
        최규현 = 최규현SignUpRequest.toEntity("password");
        ReflectionTestUtils.setField(최규현, "userId", 1L);
        장재우 = 장재우SignUpRequest.toEntity("password");
        ReflectionTestUtils.setField(장재우, "userId", 2L);
    }

    private void initCreateStudyRequest() {
        알고리즘스터디CreateRequest = CreateStudyRequest.builder()
                .studyName("알고리즘")
                .detail("내용1")
                .build();
        영어스터디CreateRequest = CreateStudyRequest.builder()
                .studyName("영어")
                .detail("내용2")
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
                .studyId(-1L)
                .title("공지사항1")
                .contents("내용1")
                .build();
    }

    private void initParticipant() {
        스터디참여자_최규현 = Participant.builder()
                .user(최규현)
                .study(알고리즘스터디)
                .build();
    }

    private void initNotice() {
        공지사항1 = 공지사항1CreateRequest.toEntity(최규현, 알고리즘스터디);
        ReflectionTestUtils.setField(공지사항1, "noticeId", 5L);
        공지사항2 = 공지사항1CreateRequest.toEntity(최규현, 알고리즘스터디);
        ReflectionTestUtils.setField(공지사항2, "noticeId", 5L);
        공지사항3 = 공지사항1CreateRequest.toEntity(최규현, 알고리즘스터디);
        ReflectionTestUtils.setField(공지사항3, "noticeId", 5L);
        공지사항4 = 공지사항1CreateRequest.toEntity(최규현, 알고리즘스터디);
        ReflectionTestUtils.setField(공지사항4, "noticeId", 5L);
    }

    private void initCreateCommentRequest(){
        댓글1CreateRequest = CreateCommentRequest.builder()
                .noticeId(-1L)
                .contents("댓글 내용1")
                .build();
        댓글2CreateRequest = CreateCommentRequest.builder()
                .noticeId(-1L)
                .contents("댓글 내용2")
                .build();
        대댓글1CreateRequest = CreateCommentRequest.builder()
                .noticeId(-1L)
                .contents("대댓글 내용1")
                .build();
    }

    private void initComment(){
        댓글1 = 댓글1CreateRequest.toEntity(최규현, 공지사항1, null);
        ReflectionTestUtils.setField(댓글1, "commentId", 7L);
        댓글2 = 댓글2CreateRequest.toEntity(최규현, 공지사항1, null);
        ReflectionTestUtils.setField(댓글2, "commentId", 9L);
        대댓글1 = 대댓글1CreateRequest.toEntity(최규현, 공지사항1, 댓글1);
        ReflectionTestUtils.setField(대댓글1, "commentId", 8L);
    }

    private void initCreateRoundRequest() {
        회차1AppointmentRequest = AppointmentRequest.builder()
                .studyPlace("규현집")
                .studyTime(LocalDateTime.of(2023, 5, 17, 16, 0))
                .build();
        회차2AppointmentRequest_EmptyTimeAndPlace = AppointmentRequest.builder()
                .studyPlace("재우집")
                .studyTime(LocalDateTime.of(2024, 5, 17, 16, 0))
                .build();
    }

    private void initRound() {
        회차1 = 회차1AppointmentRequest.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차1, "roundId", 15L);
        회차2_EmptyTimeAndPlace = 회차2AppointmentRequest_EmptyTimeAndPlace.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차2_EmptyTimeAndPlace, "roundId", 18L);
    }

    private void initRoundParticipant() {
        회차1_최규현 = new RoundParticipant(최규현, 회차1);
        회차1_장재우 = new RoundParticipant(장재우, 회차1);
    }

    private void initTask() {
        그룹태스크 = Task.builder()
                .detail("그룹태스크 detail")
                .taskType(TaskType.GROUP)
                .roundParticipant(회차1_최규현)
                .build();
        ReflectionTestUtils.setField(그룹태스크, "id", 19L);
        개인태스크 = Task.builder()
                .detail("개인태스크 detail")
                .taskType(TaskType.PERSONAL)
                .roundParticipant(회차1_최규현)
                .build();
        ReflectionTestUtils.setField(개인태스크, "id", 20L);
    }
}
