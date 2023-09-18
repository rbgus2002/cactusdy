package ssu.groupstudy.domain.common;

import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.repository.CheckNoticeRepository;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.repository.ParticipantRepository;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

@CustomRepositoryTest
public class RepositoryTest {
    @Autowired
    protected StudyRepository studyRepository;
    @Autowired
    protected UserRepository userRepository;
    @Autowired
    protected ParticipantRepository participantRepository;
    @Autowired
    protected NoticeRepository noticeRepository;
    @Autowired
    protected CheckNoticeRepository checkNoticeRepository;
    @Autowired
    protected RoundRepository roundRepository;
    @Autowired
    protected RoundParticipantRepository roundParticipantRepository;
    @Autowired
    protected CommentRepository commentRepository;


    protected User 최규현;
    protected User 장재우;
    protected User 홍예지;
    protected Study 알고리즘스터디;
    protected Notice 공지사항1;
    protected Notice 공지사항2;
    protected Notice 공지사항3;
    protected Notice 공지사항4;
    protected Comment 댓글1;
    protected Comment 댓글2;
    protected Comment 대댓글1;
    protected Comment 대댓글2;
    protected Round 회차1;

    @BeforeEach
    void initDummyData() {
        최규현 = new SignUpRequest("최규현", "규규", "rbgus2002@naver.com").toEntity();
        장재우 = new SignUpRequest("장재우", "킹적화", "arkady@naver.com").toEntity();
        홍예지 = new SignUpRequest("홍예지", "찡찡이", "are_you_hungry@question.com").toEntity();

        알고리즘스터디 = new CreateStudyRequest("알고리즘스터디", "화이팅", "", -1L).toEntity(최규현);

        공지사항1 = new CreateNoticeRequest("공지사항1", "상세내용1", -1L, -1L).toEntity(최규현, 알고리즘스터디);
        공지사항2 = new CreateNoticeRequest("공지사항2", "상세내용2", -1L, -1L).toEntity(최규현, 알고리즘스터디);
        공지사항3 = new CreateNoticeRequest("공지사항3", "상세내용3", -1L, -1L).toEntity(최규현, 알고리즘스터디);
        공지사항4 = new CreateNoticeRequest("공지사항4", "상세내용4", -1L, -1L).toEntity(최규현, 알고리즘스터디);

        댓글1 = new CreateCommentRequest(-1L, -1L, "댓글1", null).toEntity(최규현, 공지사항1);
        댓글2 = new CreateCommentRequest(-1L, -1L, "댓글2", null).toEntity(최규현, 공지사항1);

        대댓글1 = new CreateCommentRequest(-1L, -1L, "대댓글1", -1L).toEntity(최규현, 공지사항1, 댓글1);
        대댓글2 = new CreateCommentRequest(-1L, -1L, "대댓글2", -1L).toEntity(최규현, 공지사항1, 댓글1);

        회차1 = new AppointmentRequest().toEntity(알고리즘스터디);
    }
}
