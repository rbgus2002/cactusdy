package ssu.groupstudy.domain.comment.param.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.comment.param.CommentDto;
import ssu.groupstudy.domain.common.ServiceTest;

import static org.junit.jupiter.api.Assertions.*;

class CommentDtoTest extends ServiceTest {
    @Test
    @DisplayName("삭제된 댓글인 경우 삭제 처리한다.")
    void processDeletedComment(){
        // given
        댓글1.delete();

        // when
        CommentDto 댓글1Info = CommentDto.from(댓글1);

        // then
        assertEquals("(삭제)", 댓글1Info.getNickname());
        assertEquals("삭제된 댓글입니다.", 댓글1Info.getContents());
    }
}