package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.task.entity.TaskEntity;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.util.FcmUtils;

import java.util.Map;

import static ssu.groupstudy.global.util.StringUtils.buildMessage;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationService {
    private final UserEntityRepository userEntityRepository;
    private final TaskEntityRepository taskEntityRepository;
    private final FcmUtils fcmUtils;

    public void stabParticipant(UserEntity me, Long targetUserId, Long studyId, int count) {
        UserEntity target = userEntityRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        String title = buildMessage("콕찌르기 | ", me.getNickname());
        String body = buildMessage("\"", buildStabMessage(count), "\"");

        Map<String, String> data = Map.of("type", "study", "studyId", studyId.toString());
        fcmUtils.sendNotificationByTokens(target.getFcmTokenList(), title, body, data);
    }

    private String buildStabMessage(int count) {
        if (count > 1) {
            return buildMessage(String.valueOf(count), "번이나 콕 찔렀어요");
        }
        return buildMessage("콕 찔렀어요");
    }

    public void stabParticipantTask(UserEntity me, Long targetUserId, Long studyId, Long roundId, Long taskId, int count) {
        UserEntity target = userEntityRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        TaskEntity task = taskEntityRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(ResultCode.TASK_NOT_FOUND));

        String title = buildMessage("과제 콕찌르기 | ", me.getNickname());
        String body = buildMessage("\"", task.getDetail(), "\"", " : ", buildStabMessage(count));

        Map<String, String> data = Map.of("type", "round", "studyId", studyId.toString(), "roundId", roundId.toString(), "roundSeq", "-");
        fcmUtils.sendNotificationByTokens(target.getFcmTokenList(), title, body, data);
    }
}
