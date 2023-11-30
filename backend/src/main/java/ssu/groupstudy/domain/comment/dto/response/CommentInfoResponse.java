package ssu.groupstudy.domain.comment.dto.response;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommentInfoResponse {
    private int commentCount;
    private List<CommentDto> commentInfos;

    private CommentInfoResponse(int commentCount, List<CommentDto> commentInfos) {
        this.commentCount = commentCount;
        this.commentInfos = commentInfos;
    }

    public static CommentInfoResponse of(int commentCount, List<CommentDto> commentDtoList){
        return new CommentInfoResponse(commentCount, commentDtoList);
    }
}
