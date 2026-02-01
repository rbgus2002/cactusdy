package ssu.groupstudy.domain.notification.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import ssu.groupstudy.api.notification.vo.NotificationHistoryPageResVo;
import ssu.groupstudy.api.notification.vo.NotificationReadReqVo;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.exception.BusinessException;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.notification.exception.NotificationHistoryNotFoundException;
import ssu.groupstudy.domain.notification.repository.NotificationHistoryEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.*;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class NotificationHistoryService {
    private final NotificationHistoryEntityRepository notificationHistoryEntityRepository;
    private final UserEntityRepository userEntityRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public void saveNotificationHistory(UserEntity user, NotificationDataType notificationDataType,
                                        String title, String message,
                                        Map<String, String> eventData) {
        String eventDataJson;
        try {
            eventDataJson = objectMapper.writeValueAsString(eventData);
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize eventData to JSON: {}", eventData, e);
            eventDataJson = "{}";
        }

        NotificationHistoryEntity notificationHistory = NotificationHistoryEntity.builder()
                .user(user)
                .notificationDataType(notificationDataType)
                .title(title)
                .message(message)
                .eventData(eventDataJson)
                .isRead(false)
                .build();

        notificationHistoryEntityRepository.save(notificationHistory);
    }

    @Transactional(readOnly = true)
    public NotificationHistoryPageResVo getNotificationHistories(long userId, Pageable pageable) {
        UserEntity user = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        Page<NotificationHistoryEntity> notificationHistoryPage = notificationHistoryEntityRepository.findByUserOrderByCreateDateDesc(user, pageable);

        return NotificationHistoryPageResVo.of(notificationHistoryPage);
    }

    public void readNotifications(Long userId, NotificationReadReqVo request, UserEntity requester) {
        if (!requester.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.FORBIDDEN);
        }

        UserEntity user = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        if (request.getReadAll()) {
            List<NotificationHistoryEntity> unreadNotifications = notificationHistoryEntityRepository.findByUserAndIsReadFalse(user);
            unreadNotifications.forEach(NotificationHistoryEntity::markRead);
            return;
        }

        Set<Long> notificationIds = request.getNotificationIds();
        if (CollectionUtils.isEmpty(notificationIds)) {
            throw new BusinessException(ResultCode.INVALID_METHOD_ARGUMENT);
        }

        List<NotificationHistoryEntity> notificationHistories = notificationHistoryEntityRepository.findByIdInAndUser(notificationIds, user);
        if (notificationHistories.isEmpty()) {
            throw new NotificationHistoryNotFoundException(ResultCode.NOTIFICATION_HISTORY_NOT_FOUND);
        }

        notificationHistories.forEach(NotificationHistoryEntity::markRead);
    }

    public void deleteTaskDoneHistory(UserEntity user, Long taskId) {
        List<NotificationHistoryEntity> histories = notificationHistoryEntityRepository.findByUserAndNotificationDataType(user, NotificationDataType.ROUND);
        if (histories.isEmpty()) {
            return;
        }

        List<NotificationHistoryEntity> toDelete = new ArrayList<>();
        for (NotificationHistoryEntity history : histories) {
            if (hasTaskId(history.getEventData(), taskId)) {
                toDelete.add(history);
            }
        }

        if (!toDelete.isEmpty()) {
            notificationHistoryEntityRepository.deleteAllInBatch(toDelete);
        }
    }

    private boolean hasTaskId(String eventData, Long taskId) {
        try {
            Map<String, Object> eventDataMap = objectMapper.readValue(eventData, new TypeReference<Map<String, Object>>() {});
            Object storedTaskId = eventDataMap.get("taskId");
            if (storedTaskId == null) {
                return false;
            }
            return Long.valueOf(storedTaskId.toString()).equals(taskId);
        } catch (Exception e) {
            log.warn("Failed to parse eventData JSON for taskId: {}", eventData, e);
            return false;
        }
    }
}
