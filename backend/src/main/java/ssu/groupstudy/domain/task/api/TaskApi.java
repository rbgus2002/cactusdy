package ssu.groupstudy.domain.task.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.task.dto.CreateTaskRequest;
import ssu.groupstudy.domain.task.dto.UpdateTaskRequest;
import ssu.groupstudy.domain.task.dto.TaskResponse;
import ssu.groupstudy.domain.task.service.TaskService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/tasks")
@Tag(name = "Task", description = "할일 API")
public class TaskApi {
    private final TaskService taskService;

    @Operation(summary = "회차의 태스크 목록 조회", description = "특정 회차에 태스크 목록을 모두 가져온다.")
    @GetMapping
    public ResponseDto getTasks(@RequestParam Long roundId){
        List<TaskResponse> tasks = taskService.getTasks(roundId);
        return DataResponseDto.of("tasks", tasks);
    }

    @Operation(summary = "태스크 생성", description = "그룹 혹은 개인 태스크를 생성한다. 그룹 태스크 생성 시에 회차 참여자들 모두에게 태스크가 할당된다. (GROUP / PERSONAL)")
    @PostMapping
    public ResponseDto createTask(@Valid @RequestBody CreateTaskRequest request){
        taskService.createTask(request);
        return ResponseDto.success();
    }

    @Operation(summary = "태스크 삭제", description = "태스크를 완전히 삭제한다. (삭제 여부 플래그 존재X)")
    @DeleteMapping
    public ResponseDto deleteTask(@RequestParam Long taskId, @RequestParam Long roundParticipantId){
        taskService.deleteTask(taskId, roundParticipantId);
        return ResponseDto.success();
    }

    @Operation(summary = "태스크 수정", description = "태스크의 내용을 수정한다")
    @PatchMapping
    public ResponseDto updateTaskDetail(@Valid @RequestBody UpdateTaskRequest request){
        taskService.updateTaskDetail(request);
        return ResponseDto.success();
    }

    @Operation(summary = "태스크 수행 여부 변경", description = "태스크 수행 여부를 체크하거나 언체크한다")
    @PatchMapping("/check")
    public ResponseDto switchTask(@RequestParam Long taskId, @RequestParam Long roundParticipantId){
        char doneYn = taskService.switchTask(taskId, roundParticipantId);
        return DataResponseDto.of("doneYn", doneYn);
    }

}
