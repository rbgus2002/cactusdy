package ssu.groupstudy.domain.task.service;

import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.domain.event.push.TaskDoneEvent;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.round.domain.RoundParticipant;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantRepository;
import ssu.groupstudy.domain.round.repository.RoundRepository;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.task.entity.TaskType;
import ssu.groupstudy.domain.task.dto.request.CreateGroupTaskRequest;
import ssu.groupstudy.domain.task.dto.request.CreatePersonalTaskRequest;
import ssu.groupstudy.domain.task.dto.request.UpdateTaskRequest;
import ssu.groupstudy.domain.task.dto.response.GroupTaskInfoResponse;
import ssu.groupstudy.domain.task.dto.response.TaskResponse;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.constant.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TaskService {
    private final TaskRepository taskRepository;
    private final RoundRepository roundRepository;
    private final RoundParticipantRepository roundParticipantRepository;
    private final ApplicationEventPublisher eventPublisher;

    public List<TaskResponse> getTasks(Long roundId, UserEntity user) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));

        return round.getRoundParticipants().stream()
                .sorted(Comparator.comparing((RoundParticipant rp) -> !rp.getUser().equals(user))
                        .thenComparing(RoundParticipant::getId))
                .map(TaskResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Long createPersonalTask(CreatePersonalTaskRequest request) {
        RoundParticipant roundParticipant = roundParticipantRepository.findById(request.getRoundParticipantId())
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        return processTaskCreation(roundParticipant, request.getDetail(), TaskType.PERSONAL);
    }

    private Long processTaskCreation(RoundParticipant roundParticipant, String detail, TaskType taskType) {
        TaskEntity task = TaskEntity.of(detail, taskType, roundParticipant);
        return taskRepository.save(task).getId();
    }

    @Transactional
    public List<GroupTaskInfoResponse> createGroupTask(CreateGroupTaskRequest request) {
        Round round = roundRepository.findById(request.getRoundId())
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        return getGroupTaskInfoResponseList(request, round);
    }

    private List<GroupTaskInfoResponse> getGroupTaskInfoResponseList(CreateGroupTaskRequest request, Round round) {
        return round.getRoundParticipants().stream()
                .map(roundParticipant -> {
                    Long newTaskId = processTaskCreation(roundParticipant, request.getDetail(), TaskType.GROUP);
                    Long roundParticipantId = roundParticipant.getId();
                    Long userId = roundParticipant.getUser().getUserId();
                    return GroupTaskInfoResponse.of(newTaskId, roundParticipantId, userId);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteTask(Long taskId, Long roundParticipantId) {
        TaskEntity task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        RoundParticipant roundParticipant = roundParticipantRepository.findById(roundParticipantId)
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        task.validateAccess(roundParticipant);
        taskRepository.delete(task);
    }

    @Transactional
    public void updateTaskDetail(UpdateTaskRequest request) {
        TaskEntity task = taskRepository.findById(request.getTaskId())
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        task.setDetail(request.getDetail());
    }

    @Transactional
    public char switchTask(Long taskId, UserEntity user) {
        TaskEntity task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        char doneYn = task.switchDoneYn();
        processNotification(task, user);
        return doneYn;
    }

    private void processNotification(TaskEntity task, UserEntity user) {
        if (task.isDone()) {
            eventPublisher.publishEvent(new TaskDoneEvent(user, task));
        }
    }
}
