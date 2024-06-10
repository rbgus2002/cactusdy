package ssu.groupstudy.domain.common;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.assertj.core.api.junit.jupiter.SoftAssertionsExtension;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.api.comment.vo.CreateCommentReqVo;
import ssu.groupstudy.api.notice.vo.CreateNoticeReqVo;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.api.round.vo.AppointmentReqVo;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.api.study.vo.CreateStudyReqVo;
import ssu.groupstudy.domain.study.entity.ParticipantEntity;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.time.LocalDateTime;

/**
 * 모든 엔티티는 id를 갖으며 영속화 되어있다고 생각한다.
 */
@ExtendWith(MockitoExtension.class)
@ExtendWith(SoftAssertionsExtension.class)
public class ServiceTest {
    @InjectSoftAssertions
    protected SoftAssertions softly;
    protected SignUpReqVo 최규현SignUpReqVo;
    protected SignUpReqVo 장재우SignUpReqVo;
    protected UserEntity 최규현;
    protected UserEntity 장재우;

    protected CreateStudyReqVo 알고리즘스터디CreateRequest;
    protected CreateStudyReqVo 영어스터디CreateRequest;
    protected StudyEntity 알고리즘스터디;
    protected StudyEntity 영어스터디;

    protected ParticipantEntity 스터디참여자_최규현;

    protected CreateNoticeReqVo 공지사항1CreateRequest;
    protected NoticeEntity 공지사항1;
    protected NoticeEntity 공지사항2;
    protected NoticeEntity 공지사항3;
    protected NoticeEntity 공지사항4;

    protected CreateCommentReqVo 댓글1CreateRequest;
    protected CreateCommentReqVo 댓글2CreateRequest;
    protected CreateCommentReqVo 대댓글1CreateRequest;
    protected CommentEntity 댓글1;
    protected CommentEntity 댓글2;
    protected CommentEntity 대댓글1;

    protected AppointmentReqVo 회차1AppointmentReqVo;
    protected AppointmentReqVo 회차2AppointmentReqVo_EmptyTimeAndPlace;
    protected RoundEntity 회차1;
    protected RoundEntity 회차2_EmptyTimeAndPlace;

    protected RoundParticipantEntity 회차1_최규현;
    protected RoundParticipantEntity 회차1_장재우;

    protected TaskEntity 그룹태스크;
    protected TaskEntity 개인태스크;

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
        최규현SignUpReqVo = SignUpReqVo.builder()
                .name("최규현")
                .phoneNumber("rbgus200@naver.com")
                .password("valid")
                .nickname("규규")
                .build();
        장재우SignUpReqVo = SignUpReqVo.builder()
                .name("장재우")
                .phoneNumber("arkady@naver.com")
                .password("password")
                .nickname("킹적화")
                .build();
    }

    private void initUser() {
        최규현 = 최규현SignUpReqVo.toEntity("password");
        ReflectionTestUtils.setField(최규현, "userId", 1L);
        장재우 = 장재우SignUpReqVo.toEntity("password");
        ReflectionTestUtils.setField(장재우, "userId", 2L);
    }

    private void initCreateStudyRequest() {
        알고리즘스터디CreateRequest = CreateStudyReqVo.builder()
                .studyName("알고리즘")
                .detail("내용1")
                .color("0x00")
                .build();
        영어스터디CreateRequest = CreateStudyReqVo.builder()
                .studyName("영어")
                .detail("내용2")
                .color("0x00")
                .build();
    }

    private void initStudy() {
        알고리즘스터디 = 알고리즘스터디CreateRequest.toEntity(최규현, "000000");
        ReflectionTestUtils.setField(알고리즘스터디, "studyId", 3L);
        영어스터디 = 영어스터디CreateRequest.toEntity(최규현, "000000");
        ReflectionTestUtils.setField(영어스터디, "studyId", 4L);

    }

    private void initCreateNoticeRequest() {
        공지사항1CreateRequest = CreateNoticeReqVo.builder()
                .studyId(-1L)
                .title("공지사항1")
                .contents("내용1")
                .build();
    }

    private void initParticipant() {
        스터디참여자_최규현 = new ParticipantEntity(최규현, 알고리즘스터디);
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
        댓글1CreateRequest = CreateCommentReqVo.builder()
                .noticeId(-1L)
                .contents("댓글 내용1")
                .build();
        댓글2CreateRequest = CreateCommentReqVo.builder()
                .noticeId(-1L)
                .contents("댓글 내용2")
                .build();
        대댓글1CreateRequest = CreateCommentReqVo.builder()
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
        회차1AppointmentReqVo = AppointmentReqVo.builder()
                .studyPlace("규현집")
                .studyTime(LocalDateTime.of(2023, 5, 17, 16, 0))
                .build();
        회차2AppointmentReqVo_EmptyTimeAndPlace = AppointmentReqVo.builder()
                .studyPlace("재우집")
                .studyTime(LocalDateTime.of(2024, 5, 17, 16, 0))
                .build();
    }

    private void initRound() {
        회차1 = 회차1AppointmentReqVo.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차1, "roundId", 15L);
        회차2_EmptyTimeAndPlace = 회차2AppointmentReqVo_EmptyTimeAndPlace.toEntity(알고리즘스터디);
        ReflectionTestUtils.setField(회차2_EmptyTimeAndPlace, "roundId", 18L);
    }

    private void initRoundParticipant() {
        회차1_최규현 = new RoundParticipantEntity(최규현, 회차1);
        회차1_장재우 = new RoundParticipantEntity(장재우, 회차1);
    }

    private void initTask() {
        그룹태스크 = TaskEntity.builder()
                .detail("그룹태스크 detail")
                .taskType(TaskType.GROUP)
                .roundParticipant(회차1_최규현)
                .build();
        ReflectionTestUtils.setField(그룹태스크, "id", 19L);
        개인태스크 = TaskEntity.builder()
                .detail("개인태스크 detail")
                .taskType(TaskType.PERSONAL)
                .roundParticipant(회차1_최규현)
                .build();
        ReflectionTestUtils.setField(개인태스크, "id", 20L);
    }
}
