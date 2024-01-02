package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.task.domain.Task;
import ssu.groupstudy.domain.task.exception.TaskNotFoundException;
import ssu.groupstudy.domain.task.repository.TaskRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.FcmUtils;

import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationService {
    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final TaskRepository taskRepository;
    private final FcmUtils fcmUtils;

    public void notifyParticipant(User me, Long targetUserId, Long studyId, int count) {
        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        StringBuilder body = handleParticipantNotificationMessage(me, count);
        Map<String, String> data = Map.of("type", "study", "studyId", studyId.toString());
        fcmUtils.sendNotificationByTokens(target.getFcmTokenList(), study.getStudyName(), body.toString(), data);
    }

    private StringBuilder handleParticipantNotificationMessage(User me, int count) {
        StringBuilder body = new StringBuilder();
        body.append("'").append(me.getNickname()).append("'").append("님이 회원님을 ");
        if (count > 1) {
            body.append(count).append("번이나 ");
        }
        body.append("콕 찔렀어요");
        handleEmoticonByCount(body, count);
        return body;
    }

    private void handleEmoticonByCount(StringBuilder body, int count) {
        if (count <= 5) {
            body.append("❗️");
        } else {
            body.append("🔥");
        }
    }

    public void notifyParticipantTask(User user, Long targetUserId, Long studyId, Long roundId, Long taskId, int count) {
        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new TaskNotFoundException(ResultCode.TASK_NOT_FOUND));

        StringBuilder body = handleTaskNotificationMessage(user, task, count);
        Map<String, String> data = Map.of("type", "round", "studyId", studyId.toString(), "roundId", roundId.toString(), "roundSeq", "0");
        fcmUtils.sendNotificationByTokens(target.getFcmTokenList(), study.getStudyName(), body.toString(), data);
    }

    private StringBuilder handleTaskNotificationMessage(User user, Task task, int count) {
        StringBuilder body = new StringBuilder();
        body.append("'").append(user.getNickname()).append("'").append("님이 회원님의 과제를 ");
        if (count > 1) {
            body.append(count).append("번이나 ");
        }
        body.append("콕 찔렀어요");
        handleEmoticonByCount(body, count);
        body.append(": ").append(task.getDetail());
        return body;
    }

    @Transactional
    public void deleteFcmToken(User user, String token) {
        user.deleteFcmToken(token);
    }
}
