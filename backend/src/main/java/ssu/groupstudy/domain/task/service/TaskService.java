package ssu.groupstudy.domain.task.service;

import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.event.push.TaskDoneEvent;
import ssu.groupstudy.domain.round.entity.RoundEntity;
import ssu.groupstudy.domain.round.entity.RoundParticipantEntity;
import ssu.groupstudy.domain.round.exception.RoundNotFoundException;
import ssu.groupstudy.domain.round.exception.RoundParticipantNotFoundException;
import ssu.groupstudy.domain.round.repository.RoundParticipantEntityRepository;
import ssu.groupstudy.domain.round.repository.RoundEntityRepository;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.common.enums.TaskType;
import ssu.groupstudy.api.task.vo.CreateGroupTaskReqVo;
import ssu.groupstudy.api.task.vo.CreatePersonalTaskReqVo;
import ssu.groupstudy.api.task.vo.UpdateTaskReqVo;
import ssu.groupstudy.api.task.vo.GroupTaskInfoResVo;
import ssu.groupstudy.api.task.vo.TaskResVo;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import static ssu.groupstudy.global.constant.ResultCode.*;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TaskService {
    private final TaskEntityRepository taskEntityRepository;
    private final RoundEntityRepository roundEntityRepository;
    private final RoundParticipantEntityRepository roundParticipantEntityRepository;
    private final ApplicationEventPublisher eventPublisher;

    public List<TaskResVo> getTasks(Long roundId, UserEntity user) {
        RoundEntity round = roundEntityRepository.findById(roundId)
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));

        return round.getRoundParticipants().stream()
                .sorted(Comparator.comparing((RoundParticipantEntity rp) -> !rp.getUser().equals(user))
                        .thenComparing(RoundParticipantEntity::getId))
                .map(TaskResVo::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public Long createPersonalTask(CreatePersonalTaskReqVo request) {
        RoundParticipantEntity roundParticipant = roundParticipantEntityRepository.findById(request.getRoundParticipantId())
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        return processTaskCreation(roundParticipant, request.getDetail(), TaskType.PERSONAL);
    }

    private Long processTaskCreation(RoundParticipantEntity roundParticipant, String detail, TaskType taskType) {
        TaskEntity task = TaskEntity.of(detail, taskType, roundParticipant);
        return taskEntityRepository.save(task).getId();
    }

    @Transactional
    public List<GroupTaskInfoResVo> createGroupTask(CreateGroupTaskReqVo request) {
        RoundEntity round = roundEntityRepository.findById(request.getRoundId())
                .orElseThrow(() -> new RoundNotFoundException(ROUND_NOT_FOUND));
        return getGroupTaskInfoResponseList(request, round);
    }

    private List<GroupTaskInfoResVo> getGroupTaskInfoResponseList(CreateGroupTaskReqVo request, RoundEntity round) {
        return round.getRoundParticipants().stream()
                .map(roundParticipant -> {
                    Long newTaskId = processTaskCreation(roundParticipant, request.getDetail(), TaskType.GROUP);
                    Long roundParticipantId = roundParticipant.getId();
                    Long userId = roundParticipant.getUser().getUserId();
                    return GroupTaskInfoResVo.of(newTaskId, roundParticipantId, userId);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteTask(Long taskId, Long roundParticipantId) {
        TaskEntity task = taskEntityRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        RoundParticipantEntity roundParticipant = roundParticipantEntityRepository.findById(roundParticipantId)
                .orElseThrow(() -> new RoundParticipantNotFoundException(ROUND_PARTICIPANT_NOT_FOUND));
        task.validateAccess(roundParticipant);
        taskEntityRepository.delete(task);
    }

    @Transactional
    public void updateTaskDetail(UpdateTaskReqVo request) {
        TaskEntity task = taskEntityRepository.findById(request.getTaskId())
                .orElseThrow(() -> new TaskNotFoundException(TASK_NOT_FOUND));
        task.setDetail(request.getDetail());
    }

    @Transactional
    public char switchTask(Long taskId, UserEntity user) {
        TaskEntity task = taskEntityRepository.findById(taskId)
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
