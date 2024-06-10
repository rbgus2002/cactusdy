package ssu.groupstudy.api.comment.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.param.CommentDto;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommentInfoResVo {
    private int commentCount;
    private List<CommentDto> commentInfos;

    private CommentInfoResVo(int commentCount, List<CommentDto> commentInfos) {
        this.commentCount = commentCount;
        this.commentInfos = commentInfos;
    }

    public static CommentInfoResVo of(int commentCount, List<CommentDto> commentDtoList){
        return new CommentInfoResVo(commentCount, commentDtoList);
    }
}
