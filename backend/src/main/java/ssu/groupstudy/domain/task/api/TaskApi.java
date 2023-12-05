package ssu.groupstudy.domain.task.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.task.dto.request.CreateGroupTaskRequest;
import ssu.groupstudy.domain.task.dto.request.CreatePersonalTaskRequest;
import ssu.groupstudy.domain.task.dto.request.UpdateTaskRequest;
import ssu.groupstudy.domain.task.dto.response.GroupTaskInfoResponse;
import ssu.groupstudy.domain.task.dto.response.TaskResponse;
import ssu.groupstudy.domain.task.service.TaskService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tasks")
@Tag(name = "Task", description = "할일 API")
public class TaskApi {
    private final TaskService taskService;

    @Operation(summary = "회차의 과제 목록 조회", description = "특정 회차에 과제 목록을 모두 가져온다.")
    @GetMapping
    public ResponseDto getTasks(@RequestParam Long roundId, @AuthenticationPrincipal CustomUserDetails userDetails){
        List<TaskResponse> tasks = taskService.getTasks(roundId, userDetails.getUser());
        return DataResponseDto.of("tasks", tasks);
    }

    @Operation(summary = "개인 과제 생성")
    @PostMapping("/personal")
    public ResponseDto createPersonalTask(@Valid @RequestBody CreatePersonalTaskRequest request){
        Long taskId = taskService.createPersonalTask(request);
        return DataResponseDto.of("taskId", taskId);
    }

    @Operation(summary = "그룹 과제 생성")
    @PostMapping("/group")
    public ResponseDto createGroupTask(@Valid @RequestBody CreateGroupTaskRequest request){
        List<GroupTaskInfoResponse> groupTasks = taskService.createGroupTask(request);
        return DataResponseDto.of("groupTasks", groupTasks);
    }


    @Operation(summary = "과제 삭제", description = "과제를 완전히 삭제한다 (삭제 여부 플래그 존재X)")
    @DeleteMapping
    public ResponseDto deleteTask(@RequestParam Long taskId, @RequestParam Long roundParticipantId){
        taskService.deleteTask(taskId, roundParticipantId);
        return ResponseDto.success();
    }

    @Operation(summary = "과제 수정", description = "과제의 내용을 수정한다")
    @PatchMapping
    public ResponseDto updateTaskDetail(@Valid @RequestBody UpdateTaskRequest request){
        taskService.updateTaskDetail(request);
        return ResponseDto.success();
    }

    @Operation(summary = "과제 수행 여부 변경", description = "과제 수행 여부를 체크하거나 언체크한다")
    @PatchMapping("/check")
    public ResponseDto switchTask(@RequestParam Long taskId, @AuthenticationPrincipal CustomUserDetails userDetails){
        char doneYn = taskService.switchTask(taskId, userDetails.getUser());
        return DataResponseDto.of("doneYn", doneYn);
    }

}
