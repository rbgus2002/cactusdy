package ssu.groupstudy.domain.common;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

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

    @BeforeEach
    void initDummyData() {
        initSignUpRequest();
        initUser();
        initCreateStudyRequest();
        initStudy();
        initCreateNoticeRequest();
        initNotice();
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
}
