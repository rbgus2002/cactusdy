package ssu.groupstudy.domain.notice.service;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.api.notice.vo.CreateNoticeReqVo;
import ssu.groupstudy.api.notice.vo.EditNoticeReqVo;
import ssu.groupstudy.api.notice.vo.NoticeInfoResVo;
import ssu.groupstudy.domain.comment.repository.CommentEntityRepository;
import ssu.groupstudy.domain.notice.entity.CheckNoticeEntity;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.param.NoticeSummaries;
import ssu.groupstudy.domain.notice.param.NoticeSummary;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.notification.event.push.NoticeCreationEvent;
import ssu.groupstudy.domain.notification.event.subscribe.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static ssu.groupstudy.domain.common.enums.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class NoticeService {
    private final UserRepository userRepository;
    private final StudyEntityRepository studyEntityRepository;
    private final NoticeEntityRepository noticeEntityRepository;
    private final CommentEntityRepository commentEntityRepository;
    private final ApplicationEventPublisher eventPublisher;

    @Transactional
    public NoticeInfoResVo createNotice(CreateNoticeReqVo dto, Long userId) {
        StudyEntity study = studyEntityRepository.findById(dto.getStudyId())
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        UserEntity writer = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(USER_NOT_FOUND));
        NoticeEntity notice = noticeEntityRepository.save(dto.toEntity(writer, study));

        eventPublisher.publishEvent(new NoticeCreationEvent(writer, study, notice));
        eventPublisher.publishEvent(new NoticeTopicSubscribeEvent(writer, notice));

        return NoticeInfoResVo.of(notice, writer);
    }

    @Transactional
    public Character switchCheckNotice(Long noticeId, UserEntity user) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return notice.switchCheckNotice(user);
    }

    public NoticeSummaries getNoticeSummaries(Long studyId, Pageable pageable, UserEntity user) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return transformNoticeSummaries(study, pageable, user);
    }

    private NoticeSummaries transformNoticeSummaries(StudyEntity study, Pageable pageable, UserEntity user) {
        Page<NoticeEntity> noticePage = noticeEntityRepository.findNoticesByStudyOrderByPinYnDescCreateDateDesc(study, pageable);
        List<NoticeSummary> noticeSummaries = noticePage.getContent().stream()
                .map(notice -> createNoticeSummary(notice, user))
                .collect(Collectors.toList());
        return NoticeSummaries.of(noticePage, noticeSummaries);
    }

    private NoticeSummary createNoticeSummary(NoticeEntity notice, UserEntity user) {
        int commentCount = commentEntityRepository.countCommentByNotice(notice);
        int readCount = notice.countReadNotices();
        boolean isRead = notice.isRead(user);
        return NoticeSummary.of(notice, commentCount, readCount, isRead);
    }

    public List<NoticeSummary> getNoticeSummaryListLimit3(Long studyId) {
        StudyEntity study = studyEntityRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(STUDY_NOT_FOUND));
        return noticeEntityRepository.findTop3ByStudyOrderByPinYnDescCreateDateDesc(study).stream()
                .map(NoticeSummary::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Character switchNoticePin(Long noticeId) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return notice.switchPin();
    }

    public List<String> getCheckUserImageList(Long noticeId) {
        Set<CheckNoticeEntity> checkNotices = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND))
                .getCheckNotices();

        return checkNotices.stream()
                .map(checkNotice -> checkNotice.getUser().getPicture())
                .collect(Collectors.toList());
    }

    public NoticeInfoResVo getNoticeById(Long noticeId, UserEntity user) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        return NoticeInfoResVo.of(notice, user);
    }

    @Transactional
    public void delete(Long noticeId) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        notice.delete();
    }

    @Transactional
    public void updateNotice(Long noticeId, EditNoticeReqVo dto) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        notice.updateTitleAndContents(dto.getTitle(), dto.getContents());
    }
}
