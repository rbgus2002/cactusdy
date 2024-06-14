package ssu.groupstudy.api.task.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.task.vo.CreateGroupTaskReqVo;
import ssu.groupstudy.api.task.vo.CreatePersonalTaskReqVo;
import ssu.groupstudy.api.task.vo.UpdateTaskReqVo;
import ssu.groupstudy.api.task.vo.GroupTaskInfoResVo;
import ssu.groupstudy.api.task.vo.TaskResVo;
import ssu.groupstudy.domain.task.service.TaskService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tasks")
@Tag(name = "TaskEntity", description = "할일 API")
public class TaskController {
    private final TaskService taskService;

    @Operation(summary = "회차의 과제 목록 조회", description = "특정 회차에 과제 목록을 모두 가져온다.")
    @GetMapping
    public ResVo getTasks(@RequestParam Long roundId, @AuthenticationPrincipal CustomUserDetails userDetails){
        List<TaskResVo> tasks = taskService.getTasks(roundId, userDetails.getUser());
        return DataResVo.of("tasks", tasks);
    }

    @Operation(summary = "개인 과제 생성")
    @PostMapping("/personal")
    public ResVo createPersonalTask(@Valid @RequestBody CreatePersonalTaskReqVo request){
        Long taskId = taskService.createPersonalTask(request);
        return DataResVo.of("taskId", taskId);
    }

    @Operation(summary = "그룹 과제 생성")
    @PostMapping("/group")
    public ResVo createGroupTask(@Valid @RequestBody CreateGroupTaskReqVo request){
        List<GroupTaskInfoResVo> groupTasks = taskService.createGroupTask(request);
        return DataResVo.of("groupTasks", groupTasks);
    }


    @Operation(summary = "과제 삭제", description = "과제를 완전히 삭제한다 (삭제 여부 플래그 존재X)")
    @DeleteMapping
    public ResVo deleteTask(@RequestParam Long taskId, @RequestParam Long roundParticipantId){
        taskService.deleteTask(taskId, roundParticipantId);
        return ResVo.success();
    }

    @Operation(summary = "과제 수정", description = "과제의 내용을 수정한다")
    @PatchMapping
    public ResVo updateTaskDetail(@Valid @RequestBody UpdateTaskReqVo request){
        taskService.updateTaskDetail(request);
        return ResVo.success();
    }

    @Operation(summary = "과제 수행 여부 변경", description = "과제 수행 여부를 체크하거나 체크 해제한다")
    @PatchMapping("/check")
    public ResVo switchTask(@RequestParam Long taskId, @AuthenticationPrincipal CustomUserDetails userDetails){
        char doneYn = taskService.switchTask(taskId, userDetails.getUser());
        return DataResVo.of("doneYn", doneYn);
    }
}
