package ssu.groupstudy.domain.comment.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.service.CommentService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@Tag(name = "CommentEntity", description = "댓글 API")
public class CommentApi {
    private final CommentService commentService;

    @Operation(summary = "새로운 댓글 작성", description = "대댓글 작성의 경우에만 parentCommentId에 부모 댓글의 id를 포함해서 요청한다")
    @PostMapping
    public ResponseDto writeComment(@Valid @RequestBody CreateCommentRequest dto, @AuthenticationPrincipal CustomUserDetails userDetails){
        Long commentId = commentService.createComment(dto, userDetails.getUser());
        return DataResponseDto.of("commentId", commentId);
    }

    @Operation(summary = "공지사항에 작성된 댓글 가져오기")
    @GetMapping
    public ResponseDto viewComments(@RequestParam Long noticeId){
        CommentInfoResponse comments = commentService.getComments(noticeId);
        return DataResponseDto.of("comments", comments);
    }

    @Operation(summary = "댓글 삭제")
    @DeleteMapping
    public ResponseDto deleteComment(@RequestParam Long commentId){
        commentService.deleteComment(commentId);
        return ResponseDto.success();
    }
}
