package ssu.groupstudy.domain.task.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.task.dto.TaskResponse;
import ssu.groupstudy.domain.task.service.TaskService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/tasks")
@Tag(name = "Task", description = "할일 API")
public class TaskApi {
    private final TaskService taskService;

    @Operation(summary = "회차의 태스크 목록 조회", description = "특정 회차에 태스크 목록을 모두 가져온다.")
    @GetMapping("")
    public ResponseDto getTasks(@RequestParam Long roundId){
        List<TaskResponse> tasks = taskService.getTasks(roundId);
        return DataResponseDto.of("tasks", tasks);
    }

    @Operation(summary = "태스크 삭제", description = "태스크를 완전히 삭제한다. (삭제 여부 플래그 존재X)")
    @DeleteMapping("")
    public ResponseDto deleteTask(@RequestParam Long taskId){
        taskService.deleteTask(taskId);
        return ResponseDto.success();
    }
}
