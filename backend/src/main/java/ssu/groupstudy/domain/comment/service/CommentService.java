package ssu.groupstudy.domain.comment.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.ChildCommentInfoResponse;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.exception.CommentNotFoundException;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.notification.domain.event.NoticeTopicSubscribeEvent;
import ssu.groupstudy.domain.user.domain.User;
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
    public Long createComment(CreateCommentRequest dto, User writer) {
        Notice notice = noticeRepository.findByNoticeId(dto.getNoticeId())
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        validateUser(writer, notice);
        eventPublisher.publishEvent(new NoticeTopicSubscribeEvent(writer, notice));

        Comment comment = handleCommentCreationWithParent(dto, writer, notice);
        return commentRepository.save(comment).getCommentId();
    }

    private void validateUser(User writer, Notice notice) {
        if(!notice.getStudy().isParticipated(writer)){
            throw new UserNotParticipatedException(USER_NOT_PARTICIPATED);
        }
    }

    /**
     * 부모 댓글이 존재하는 경우를 구분해서 생성할 Comment 객체를 생성한다
     */
    private Comment handleCommentCreationWithParent(CreateCommentRequest dto, User writer, Notice notice) {
        Comment parent = null;
        if(dto.getParentCommentId() != null){
            parent = commentRepository.getReferenceById(dto.getParentCommentId());
        }
        return dto.toEntity(writer, notice, parent);
    }

    public List<CommentInfoResponse> getComments(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(NOTICE_NOT_FOUND));
        List<Comment> parentComments = getParentComments(notice);
        return transformToCommentsWithReplies(parentComments);
    }

    private List<Comment> getParentComments(Notice notice) {
        return commentRepository.findCommentsByNoticeAndParentCommentIsNullOrderByCreateDate(notice);
    }

    private List<CommentInfoResponse> transformToCommentsWithReplies(List<Comment> parentComments){
        return parentComments.stream()
                .map(this::transformToCommentsWithReplies)
                .filter(commentInfo -> !commentInfo.requireRemoved())
                .collect(Collectors.toList());
    }

    private CommentInfoResponse transformToCommentsWithReplies(Comment comment){
        CommentInfoResponse commentInfo = CommentInfoResponse.from(comment);
        List<Comment> childComments = getChildComments(comment);
        commentInfo.appendReplies(transformToChildComments(childComments));
        return commentInfo;
    }

    private List<Comment> getChildComments(Comment comment) {
        return commentRepository.findCommentsByParentCommentOrderByCreateDate(comment);
    }

    private List<ChildCommentInfoResponse> transformToChildComments(List<Comment> childComments) {
        return childComments.stream()
                .map(ChildCommentInfoResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteComment(Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CommentNotFoundException(COMMENT_NOT_FOUND));
        comment.delete();
    }
}
