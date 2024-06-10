package ssu.groupstudy.domain.task.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;
import ssu.groupstudy.domain.common.enums.TaskType;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Getter
@AllArgsConstructor
@Builder
@ToString
public class CreateTaskRequest {
    @NotNull
    private Long roundParticipantId;

    @NotNull(message = "타입은 필수로 입력해야 합니다.")
    private TaskType taskType;

    @NotEmpty(message = "수정할 내용이 비어있을 수 없습니다.")
    @Size(max = 200, message = "태스크 내용은 200자가 넘을 수 없습니다.")
    private String detail;
}
