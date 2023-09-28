package ssu.groupstudy.domain.notice.service;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.dto.request.CreateNoticeRequest;
import ssu.groupstudy.domain.notice.dto.response.NoticeInfoResponse;
import ssu.groupstudy.domain.notice.dto.response.NoticeSummary;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.ResultCode.NOTICE_NOT_FOUND;
import static ssu.groupstudy.global.ResultCode.STUDY_NOT_FOUND;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class NoticeService {

    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final NoticeRepository noticeRepository;
    private final CommentRepository commentRepository;

    @Transactional
    public Long createNotice(CreateNoticeRequest dto, User writer) {
        Study study = studyRepository.findById(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return noticeRepository.save(dto.toEntity(writer, study)).getNoticeId();
    }

    @Transactional
    public Character switchCheckNotice(Long noticeId, User user) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return notice.switchCheckNotice(user);
    }

    public List<NoticeSummary> getNoticeSummaries(Long studyId, User user) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return transformNoticeSummaries(study, user);
    }

    private List<NoticeSummary> transformNoticeSummaries(Study study, User user) {
        List<Notice> notices = noticeRepository.findNoticesByStudyOrderByPinYnDescCreateDateDesc(study);
        return notices.stream()
                .map(notice -> createNoticeSummary(notice, user))
                .collect(Collectors.toList());
    }

    private NoticeSummary createNoticeSummary(Notice notice, User user) {
        int commentCount = commentRepository.countCommentByNotice(notice);
        int readCount = notice.countReadNotices();
        boolean isRead = notice.isRead(user);
        return NoticeSummary.of(notice, commentCount, readCount, isRead);
    }

    public List<NoticeSummary> getNoticeSummaryListLimit3(Long studyId) {
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));

        return noticeRepository.findTop3ByStudyOrderByPinYnDescCreateDateDesc(study).stream()
                .map(NoticeSummary::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Character switchNoticePin(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return notice.switchPin();
    }

    public List<String> getCheckUserImageList(Long noticeId) {
        Set<CheckNotice> checkNotices = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND))
                .getCheckNotices();

        return checkNotices.stream()
                .map(checkNotice -> checkNotice.getUser().getPicture())
                .collect(Collectors.toList());
    }

    public NoticeInfoResponse getNoticeById(Long noticeId, User user) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        int commentCount = commentRepository.countCommentByNotice(notice);
        return NoticeInfoResponse.of(notice, user, commentCount);
    }

    @Transactional
    public void delete(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        notice.deleteNotice();
    }
}
