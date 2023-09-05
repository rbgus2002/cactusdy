package ssu.groupstudy.domain.task.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.round.dto.request.AppointmentRequest;
import ssu.groupstudy.domain.task.service.TaskService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequiredArgsConstructor
@RequestMapping("/tasks")
@Tag(name = "Task", description = "할일 API")
public class TaskApi {
    private final TaskService taskService;

    @Operation(summary = "태스크 삭제", description = "태스크를 완전히 삭제한다. (삭제 여부 플래그 존재X)")
    @DeleteMapping("")
    public ResponseDto removeTask(@RequestParam Long taskId){
        taskService.removeTask(taskId);
        return ResponseDto.success();
    }
}
