package ssu.groupstudy.domain.comment.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.ChildCommentInfoResponse;
import ssu.groupstudy.domain.comment.dto.response.CommentDto;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.exception.CommentNotFoundException;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.entity.NoticeEntity;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.notification.event.push.CommentCreationEvent;
import ssu.groupstudy.domain.notification.event.subscribe.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;

import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.constant.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class CommentService {
    private final CommentRepository commentRepository;
    private final NoticeRepository noticeRepository;
    private final ApplicationEventPublisher eventPublisher;


    @Transactional
    public Long createComment(CreateCommentRequest dto, UserEntity writer) {
        NoticeEntity notice = noticeRepository.findById(dto.getNoticeId())
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        validateUser(writer, notice);
        CommentEntity comment = handleCommentCreationWithParent(dto, writer, notice);

        eventPublisher.publishEvent(new CommentCreationEvent(notice, comment));
        eventPublisher.publishEvent(new NoticeTopicSubscribeEvent(writer, notice));

        return commentRepository.save(comment).getCommentId();
    }

    private void validateUser(UserEntity writer, NoticeEntity notice) {
        if(!notice.getStudy().isParticipated(writer)){
            throw new UserNotParticipatedException(USER_NOT_PARTICIPATED);
        }
    }

    /**
     * 부모 댓글이 존재하는 경우를 구분해서 생성할 CommentEntity 객체를 생성한다
     */
    private CommentEntity handleCommentCreationWithParent(CreateCommentRequest dto, UserEntity writer, NoticeEntity notice) {
        CommentEntity parent = null;
        if(dto.getParentCommentId() != null){
            parent = commentRepository.getReferenceById(dto.getParentCommentId());
        }
        return dto.toEntity(writer, notice, parent);
    }

    public CommentInfoResponse getComments(Long noticeId) {
        NoticeEntity notice = noticeRepository.findById(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        int commentCount = commentRepository.countCommentByNotice(notice);
        List<CommentEntity> parentComments = getParentComments(notice);
        List<CommentDto> commentDtoList = transformToCommentsWithReplies(parentComments);
        return CommentInfoResponse.of(commentCount, commentDtoList);
    }

    private List<CommentEntity> getParentComments(NoticeEntity notice) {
        return commentRepository.findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(notice);
    }

    private List<CommentDto> transformToCommentsWithReplies(List<CommentEntity> parentComments){
        return parentComments.stream()
                .map(this::transformToCommentsWithReplies)
                .filter(commentInfo -> !commentInfo.requireRemoved())
                .collect(Collectors.toList());
    }

    private CommentDto transformToCommentsWithReplies(CommentEntity comment){
        CommentDto commentInfo = CommentDto.from(comment);
        List<CommentEntity> childComments = getChildComments(comment);
        commentInfo.appendReplies(transformToChildComments(childComments));
        return commentInfo;
    }

    private List<CommentEntity> getChildComments(CommentEntity comment) {
        return commentRepository.findCommentsByParentCommentOrderByCreateDate(comment);
    }

    private List<ChildCommentInfoResponse> transformToChildComments(List<CommentEntity> childComments) {
        return childComments.stream()
                .map(ChildCommentInfoResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteComment(Long commentId) {
        CommentEntity comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CommentNotFoundException(COMMENT_NOT_FOUND));
        comment.delete();
    }
}
