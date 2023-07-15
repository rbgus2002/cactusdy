package ssu.groupstudy.domain.notice.service;


import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.dto.response.NoticeInfoResponse;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.ResultCode.*;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class NoticeService {

    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final NoticeRepository noticeRepository;
    private final CommentRepository commentRepository;

    @Transactional
    public Long createNotice(CreateNoticeRequest dto) {
        User writer = userRepository.findByUserId(dto.getUserId())
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));
        Study study = studyRepository.findByStudyId(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        return noticeRepository.save(dto.toEntity(writer, study)).getNoticeId();
    }

    @Transactional
    public Character switchCheckNotice(Long noticeId, Long userId){
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));

        return notice.switchCheckNotice(user);
    }

    public List<NoticeSummary> getNoticeSummaryList(Long studyId) {
        Study study = studyRepository.findByStudyId(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        return noticeRepository.findNoticeByStudyOrderByPinYnDescCreateDateDesc(study).stream()
                .map(NoticeSummary::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Character switchNoticePin(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return notice.switchPin();
    }

    public List<String> getCheckUserImageList(Long noticeId){
        Set<CheckNotice> checkNotices = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND))
                .getCheckNotices();

        return checkNotices.stream()
                .map(checkNotice -> checkNotice.getUser().getPicture())
                .collect(Collectors.toList());
    }

    public NoticeInfoResponse getNoticeByNoticeId(Long noticeId){
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));

        Long commentCount = commentRepository.countCommentByNotice(notice);

        return NoticeInfoResponse.of(notice, commentCount);
    }
}
