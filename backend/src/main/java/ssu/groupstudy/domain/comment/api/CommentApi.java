package ssu.groupstudy.domain.comment.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.dto.response.CommentInfoResponse;
import ssu.groupstudy.domain.comment.service.CommentService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/comments")
@AllArgsConstructor
@Tag(name = "Comment", description = "댓글 API")
public class CommentApi {
    private final CommentService commentService;

    @Operation(summary = "새로운 댓글 작성", description = "대댓글 작성의 경우에만 parentCommentId에 부모 댓글의 id를 포함해서 요청한다")
    @PostMapping("")
    public ResponseDto writeComment(@Valid @RequestBody CreateCommentRequest dto){
        Long commentId = commentService.createComment(dto);

        return DataResponseDto.of("commentId", commentId);
    }

    @Operation(summary = "공지사항에 작성된 댓글 가져오기")
    @GetMapping("")
    public ResponseDto viewComments(@RequestParam Long noticeId){
        List<CommentInfoResponse> comments = commentService.getCommentsOrderByCreateDateAsc(noticeId);

        return DataResponseDto.of("comments", comments);
    }

}
