package ssu.groupstudy.domain.comment.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.comment.dto.request.CreateCommentRequest;
import ssu.groupstudy.domain.comment.service.CommentService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/comments")
@AllArgsConstructor
@Tag(name = "Comment", description = "댓글 API")
public class CommentApi {
    private final CommentService commentService;

    @Operation(summary = "새로운 댓글 작성")
    @PostMapping("")
    public ResponseDto writeComment(@Valid @RequestBody CreateCommentRequest dto){
        Long commentId = commentService.createComment(dto);

        return DataResponseDto.of("commentId", commentId);
    }
}
