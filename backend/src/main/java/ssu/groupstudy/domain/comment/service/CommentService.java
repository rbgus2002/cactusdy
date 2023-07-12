package ssu.groupstudy.domain.comment.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.repository.CommentRepository;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.notice.exception.NoticeNotFoundException;
import ssu.groupstudy.domain.notice.repository.NoticeRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
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

        return commentRepository.save(dto.toEntity(writer, notice)).getCommentId();
    }


    public List<CommentInfoResponse> getCommentsOrderByCreateDateAsc(Long noticeId) {
        Notice notice = noticeRepository.findByNoticeId(noticeId)
                .orElseThrow(() -> new NoticeNotFoundException(ResultCode.NOTICE_NOT_FOUND));

        return commentRepository.findCommentsByNoticeOrderByCreateDate(notice).stream()
                .map(CommentInfoResponse::from)
                .collect(Collectors.toList());
    }
}
