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
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.domain.TaskType;
import ssu.groupstudy.domain.task.dto.request.CreateTaskRequest;
import ssu.groupstudy.domain.task.dto.request.UpdateTaskRequest;
import ssu.groupstudy.domain.task.dto.response.TaskResponse;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskRepository;
import ssu.groupstudy.domain.user.domain.User;

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

    public List<TaskResponse> getTasks(Long roundId, User user) {
        Round round = roundRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));

        return round.getRoundParticipants().stream()
                .sorted(Comparator.comparing((RoundParticipant rp) -> !rp.getUser().equals(user))
                        .thenComparing(RoundParticipant::getId))
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
        if (taskType.isPersonalType()) {
            return processTaskCreation(roundParticipant, detail, taskType);
        } else {
            return handleGroupTaskCreation(roundParticipant, detail, taskType);
        }
    }

    private Long processTaskCreation(RoundParticipant roundParticipant, String detail, TaskType taskType) {
        Task task = Task.of(detail, taskType, roundParticipant);
        return taskRepository.save(task).getId();
    }

    private Long handleGroupTaskCreation(RoundParticipant taskCreator, String detail, TaskType taskType) {
        Round round = taskCreator.getRound();

        // 태스크 생성 후 해당 태스크의 id 반환
        Long taskId = processTaskCreation(taskCreator, detail, taskType);

        // 다른 회차 참여자들 태스크 생성
        processTaskCreationForOthers(taskCreator, detail, taskType, round);

        return taskId;
    }

    private void processTaskCreationForOthers(RoundParticipant taskCreator, String detail, TaskType taskType, Round round) {
        for (RoundParticipant roundParticipant : round.getRoundParticipants()) {
            if (!roundParticipant.equals(taskCreator)) {
                roundParticipant.createTask(detail, taskType);
            }
        }
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
        task.setDetail(request.getDetail());
    }

    @Transactional
    public char switchTask(Long taskId, User user) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        char doneYn = task.switchDoneYn();
        processNotification(task, user);
        return doneYn;
    }

    private void processNotification(Task task, User user) {
        if (task.isDone()) {
            eventPublisher.publishEvent(new TaskDoneEvent(user, task.getStudy()));
        }
    }
}
