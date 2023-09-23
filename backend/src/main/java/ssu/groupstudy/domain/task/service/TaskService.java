package ssu.groupstudy.domain.task.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.task.dto.request.CreateTaskRequest;
import ssu.groupstudy.domain.task.dto.request.UpdateTaskRequest;
import ssu.groupstudy.domain.task.dto.response.TaskResponse;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskRepository;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TaskService {
    private final TaskRepository taskRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;


    public List<TaskResponse> getTasks(Long roundId) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));

        return round.getRoundParticipants().stream()
                .sorted(Comparator.comparing(RoundParticipant::getId))
                .map(TaskResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Long createTask(CreateTaskRequest request) {
        RoundParticipant roundParticipant = roundParticipantRepository.findById(request.getRoundParticipantId())
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        String detail = request.getDetail();
        TaskType taskType = request.getTaskType();

        return handleTaskCreation(roundParticipant, detail, taskType);
    }

    private Long handleTaskCreation(RoundParticipant roundParticipant, String detail, TaskType taskType) {
        Long taskId = null;
        if(taskType.isGroupType()){
            handleGroupTaskCreation(roundParticipant, detail, taskType);
        }else{
            taskId = handlePersonalTaskCreation(roundParticipant, detail, taskType);
        }
        return taskId;
    }

    private void handleGroupTaskCreation(RoundParticipant roundParticipant, String detail, TaskType taskType) {
        Round round = roundParticipant.getRound();
        round.createGroupTaskForAll(detail, taskType);
    }

    private Long handlePersonalTaskCreation(RoundParticipant roundParticipant, String detail, TaskType taskType) {
        Task task = Task.of(detail, taskType, roundParticipant);
        return taskRepository.save(task).getId();
    }

    @Transactional
    public void deleteTask(Long taskId, Long roundParticipantId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        RoundParticipant roundParticipant = roundParticipantRepository.findById(roundParticipantId)
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        task.validateAccess(roundParticipant);

        taskRepository.delete(task);
    }

    @Transactional
    public void updateTaskDetail(UpdateTaskRequest request) {
        Task task = taskRepository.findById(request.getTaskId())
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        RoundParticipant roundParticipant = roundParticipantRepository.findById(request.getRoundParticipantId())
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        task.validateAccess(roundParticipant);

        task.setDetail(request.getDetail());
    }

    @Transactional
    public char switchTask(Long taskId, Long roundParticipantId) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        RoundParticipant roundParticipant = roundParticipantRepository.findById(roundParticipantId)
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        task.validateAccess(roundParticipant);

        return task.switchDoneYn();
    }
}
