package ssu.groupstudy.domain.comment.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import ssu.groupstudy.domain.comment.domain.Comment;
import ssu.groupstudy.domain.common.ServiceTest;

import static org.junit.jupiter.api.Assertions.*;

class CommentInfoResponseTest extends ServiceTest {
    @Test
    @DisplayName("삭제된 댓글인 경우 삭제 처리한다.")
    void processDeletedComment(){
        // given
        댓글1.delete();

        // when
        CommentInfoResponse 댓글1Info = CommentInfoResponse.from(댓글1);

        // then
        assertEquals("(삭제)", 댓글1Info.getNickname());
        assertEquals("삭제된 댓글입니다.", 댓글1Info.getContents());
    }
}