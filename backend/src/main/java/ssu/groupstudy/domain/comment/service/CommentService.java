package ssu.groupstudy.domain.comment.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.api.comment.vo.ChildCommentInfoResVo;
import ssu.groupstudy.api.comment.vo.CommentInfoResVo;
import ssu.groupstudy.api.comment.vo.CreateCommentReqVo;
import ssu.groupstudy.api.comment.vo.CreateCommentV2ReqVo;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.comment.exception.CommentNotFoundException;
import ssu.groupstudy.domain.comment.param.CommentDto;
import ssu.groupstudy.domain.comment.repository.CommentEntityRepository;
import ssu.groupstudy.domain.common.enums.TopicCode;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeEntityRepository;
import ssu.groupstudy.domain.notification.event.push.CommentCreationEvent;
import ssu.groupstudy.domain.notification.event.subscribe.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.notification.param.NotificationCommentParam;
import ssu.groupstudy.domain.notification.service.NotificationCommentService;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.domain.common.enums.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class CommentService {
    private final CommentEntityRepository commentEntityRepository;
    private final NoticeEntityRepository noticeEntityRepository;
    private final ApplicationEventPublisher eventPublisher;
    private final NotificationCommentService notificationService;


    @Deprecated
    @Transactional
    public Long createComment(CreateCommentReqVo dto, UserEntity writer) {
        NoticeEntity notice = noticeEntityRepository.findById(dto.getNoticeId())
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));

        if (!notice.getStudy().isParticipated(writer)) {
            throw new UserNotParticipatedException(USER_NOT_PARTICIPATED);
        }

        CommentEntity comment = handleCommentCreationWithParent(dto, writer, notice);

        eventPublisher.publishEvent(
                CommentCreationEvent.builder()
                        .noticeId(notice.getNoticeId())
                        .studyId(notice.getStudy().getStudyId())
                        .commentWriterNickname(writer.getNickname())
                        .commentContents(comment.getContents())
                        .build()
        );
        eventPublisher.publishEvent(
                NoticeTopicSubscribeEvent.builder()
                        .fcmTokens(writer.getFcmTokens())
                        .noticeId(notice.getNoticeId())
                        .build()
        );

        return commentEntityRepository.save(comment).getCommentId();
    }

    @Transactional
    public Long createCommentV2(Long studyId, Long noticeId, @Valid CreateCommentV2ReqVo reqVo, UserEntity writer) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        StudyEntity study = notice.getStudy();

        // 유효성 검사
        if (!study.isParticipated(writer)) {
            throw new UserNotParticipatedException(USER_NOT_PARTICIPATED);
        }

        // 알림 전송 및 토픽 구독
        notificationService.push(
                NotificationCommentParam.builder()
                        .noticeId(noticeId)
                        .studyId(studyId)
                        .commentWriterNickname(writer.getNickname())
                        .commentContents(reqVo.getContents())
                        .build()
        );
        notificationService.subscribeToFcm(writer.getFcmTokens(), TopicCode.NOTICE, noticeId);

        // 엔티티 생성
        CommentEntity parentComment = (reqVo.getParentCommentId() != null)
                ? commentEntityRepository.findById(reqVo.getParentCommentId()).orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND))
                : null;
        CommentEntity comment = reqVo.toEntity(writer, notice, parentComment);
        return commentEntityRepository.save(comment).getCommentId();
    }

    /**
     * 부모 댓글이 존재하는 경우를 구분해서 생성할 CommentEntity 객체를 생성한다
     */
    private CommentEntity handleCommentCreationWithParent(CreateCommentReqVo dto, UserEntity writer, NoticeEntity notice) {
        CommentEntity parent = null;
        if (dto.getParentCommentId() != null) {
            parent = commentEntityRepository.getReferenceById(dto.getParentCommentId()); // [2024-09-01:최규현] TODO: repo method 변경 필요
        }
        return dto.toEntity(writer, notice, parent);
    }

    public CommentInfoResVo getComments(Long noticeId) {
        NoticeEntity notice = noticeEntityRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        int commentCount = commentEntityRepository.countCommentByNotice(notice);
        List<CommentEntity> parentComments = getParentComments(notice);
        List<CommentDto> commentDtoList = transformToCommentsWithReplies(parentComments);
        return CommentInfoResVo.of(commentCount, commentDtoList);
    }

    private List<CommentEntity> getParentComments(NoticeEntity notice) {
        return commentEntityRepository.findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(notice);
    }

    private List<CommentDto> transformToCommentsWithReplies(List<CommentEntity> parentComments) {
        return parentComments.stream()
                .map(this::transformToCommentsWithReplies)
                .filter(commentInfo -> !commentInfo.requireRemoved())
                .collect(Collectors.toList());
    }

    private CommentDto transformToCommentsWithReplies(CommentEntity comment) {
        CommentDto commentInfo = CommentDto.from(comment);
        List<CommentEntity> childComments = getChildComments(comment);
        commentInfo.appendReplies(transformToChildComments(childComments));
        return commentInfo;
    }

    private List<CommentEntity> getChildComments(CommentEntity comment) {
        return commentEntityRepository.findCommentsByParentCommentOrderByCreateDate(comment);
    }

    private List<ChildCommentInfoResVo> transformToChildComments(List<CommentEntity> childComments) {
        return childComments.stream()
                .map(ChildCommentInfoResVo::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteComment(Long commentId) {
        CommentEntity comment = commentEntityRepository.findById(commentId)
                .orElseThrow(() -> new CommentNotFoundException(COMMENT_NOT_FOUND));
        comment.delete();
    }
}
