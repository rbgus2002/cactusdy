package ssu.groupstudy.domain.comment.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class CommentService {
    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final NoticeRepository noticeRepository;

    @Transactional
    public Long createComment(CreateCommentRequest dto) {
        User writer = userRepository.findByUserId(dto.getUserId())
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        Notice notice = noticeRepository.findByNoticeId(dto.getNoticeId())
                .orElseThrow(() -> new NoticeNotFoundException(ResultCode.NOTICE_NOT_FOUND));

        if(!notice.getStudy().isParticipated(writer)){
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }

        Comment comment = getCommentIncludingParent(dto, writer, notice);
        return commentRepository.save(comment).getCommentId();
    }

    /**
     * 부모 댓글이 존재하는 경우를 구분해서 생성할 Comment 객체를 생성한다
     */
    private Comment getCommentIncludingParent(CreateCommentRequest dto, User writer, Notice notice) {
        Comment comment;
        if(dto.getParentCommentId() != null){
            Comment parent = commentRepository.getReferenceById(dto.getParentCommentId());
            comment = dto.toEntity(writer, notice, parent);
        }else{
            comment = dto.toEntity(writer, notice);
        }
        return comment;
    }


    public List<CommentInfoResponse> getCommentsOrderByCreateDateAsc(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(ResultCode.NOTICE_NOT_FOUND));

        return commentRepository.findCommentsByNoticeOrderByCreateDate(notice).stream()
                .map(CommentInfoResponse::from)
                .collect(Collectors.toList());
    }
}
