package ssu.groupstudy.api.comment.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.api.comment.vo.CreateCommentV2ReqVo;
import ssu.groupstudy.api.common.vo.IdResVo;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.comment.vo.CreateCommentReqVo;
import ssu.groupstudy.api.comment.vo.CommentInfoResVo;
import ssu.groupstudy.domain.comment.service.CommentService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "CommentEntity", description = "댓글 API")
public class CommentController {
    private final CommentService commentService;

    @Operation(summary = "새로운 댓글 작성", description = "대댓글 작성의 경우에만 parentCommentId에 부모 댓글의 id를 포함해서 요청한다")
    @PostMapping("/comments")
    @Deprecated
    public ResVo writeComment(
            @Valid @RequestBody CreateCommentReqVo dto,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long commentId = commentService.createComment(dto, userDetails.getUser());
        return DataResVo.of("commentId", commentId);
    }

    @Operation(summary = "댓글 생성")
    @PostMapping("/v1/studies/{studyId}/notices/{noticeId}/comments")
    public ResponseEntity<IdResVo> writeComment(
            @PathVariable Long studyId,
            @PathVariable Long noticeId,
            @Valid @RequestBody CreateCommentV2ReqVo reqVo,
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        Long commentId = commentService.createCommentV2(studyId, noticeId, reqVo, userDetails.getUser());
        return ResponseEntity.ok(IdResVo.of(commentId));
    }

    @Operation(summary = "공지사항에 작성된 댓글 가져오기")
    @GetMapping("/comments")
    public ResVo viewComments(@RequestParam Long noticeId) {
        CommentInfoResVo comments = commentService.getComments(noticeId);
        return DataResVo.of("comments", comments);
    }

    @Operation(summary = "댓글 삭제")
    @DeleteMapping("/comments")
    public ResVo deleteComment(@RequestParam Long commentId) {
        commentService.deleteComment(commentId);
        return ResVo.success();
    }
}
