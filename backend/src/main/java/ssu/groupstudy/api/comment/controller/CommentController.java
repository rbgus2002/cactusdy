package ssu.groupstudy.api.comment.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.param.CustomUserDetails;
import ssu.groupstudy.api.comment.vo.CreateCommentReqVo;
import ssu.groupstudy.api.comment.vo.CommentInfoResVo;
import ssu.groupstudy.domain.comment.service.CommentService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@Tag(name = "CommentEntity", description = "댓글 API")
public class CommentController {
    private final CommentService commentService;

    @Operation(summary = "새로운 댓글 작성", description = "대댓글 작성의 경우에만 parentCommentId에 부모 댓글의 id를 포함해서 요청한다")
    @PostMapping
    public ResVo writeComment(@Valid @RequestBody CreateCommentReqVo dto, @AuthenticationPrincipal CustomUserDetails userDetails){
        Long commentId = commentService.createComment(dto, userDetails.getUser());
        return DataResVo.of("commentId", commentId);
    }

    @Operation(summary = "공지사항에 작성된 댓글 가져오기")
    @GetMapping
    public ResVo viewComments(@RequestParam Long noticeId){
        CommentInfoResVo comments = commentService.getComments(noticeId);
        return DataResVo.of("comments", comments);
    }

    @Operation(summary = "댓글 삭제")
    @DeleteMapping
    public ResVo deleteComment(@RequestParam Long commentId){
        commentService.deleteComment(commentId);
        return ResVo.success();
    }
}
