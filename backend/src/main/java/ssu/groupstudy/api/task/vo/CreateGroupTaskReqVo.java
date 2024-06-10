package ssu.groupstudy.api.task.vo;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

@Getter
@Builder
@ToString
public class CreateGroupTaskReqVo {
    @NotNull
    private Long roundId;

    @NotEmpty(message = "수정할 내용을 적어주세요")
    private String detail;
}
