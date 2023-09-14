package ssu.groupstudy.domain.task.dto;

import lombok.*;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@AllArgsConstructor
@Builder
public class UpdateTaskRequest {
    @NotNull
    private Long taskId;

    @NotNull
    private Long roundParticipantId;

    @NotEmpty(message = "수정할 내용이 비어있을 수 없습니다.")
    @Size(max = 200, message = "태스크 내용은 200자가 넘을 수 없습니다.")
    private String detail;
}
