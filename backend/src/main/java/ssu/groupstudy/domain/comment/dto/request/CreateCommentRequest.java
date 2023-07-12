package ssu.groupstudy.domain.comment.dto.request;

import lombok.*;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.notice.domain.Notice;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateCommentRequest {
    @NotNull
    private Long userId;

    @NotNull
    private Long noticeId;

    @NotBlank
    private String contents;

    public Comment toEntity(User writer, Notice notice){
        return Comment.builder()
                .writer(writer)
                .notice(notice)
                .contents(contents)
                .build();
    }
}
