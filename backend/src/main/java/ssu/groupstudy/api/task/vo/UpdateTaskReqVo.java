package ssu.groupstudy.api.task.vo;

import lombok.*;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@AllArgsConstructor
@Builder
@ToString
public class UpdateTaskReqVo {
    @NotNull
    private Long taskId;

    @NotEmpty(message = "수정할 내용이 비어있을 수 없습니다.")
    @Size(max = 255, message = "태스크 내용은 255자가 넘을 수 없습니다.")
    private String detail;
}
