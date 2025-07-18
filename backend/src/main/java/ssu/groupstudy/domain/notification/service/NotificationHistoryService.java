package ssu.groupstudy.domain.notification.service;

import com.google.gson.Gson;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.notification.repository.NotificationHistoryEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class NotificationHistoryService {
    private final NotificationHistoryEntityRepository notificationHistoryEntityRepository;
    private final Gson gson = new Gson();

    public void saveNotificationHistory(UserEntity user, NotificationDataType notificationDataType,
                                      String title, String message, 
                                      Map<String, String> eventData) {
        String eventDataJson = gson.toJson(eventData);
        
        NotificationHistoryEntity notificationHistory = NotificationHistoryEntity.builder()
                .user(user)
                .notificationDataType(notificationDataType)
                .title(title)
                .message(message)
                .eventData(eventDataJson)
                .build();
        
        notificationHistoryEntityRepository.save(notificationHistory);
        log.info("알림 히스토리 저장 완료 - userId: {}, notificationDataType: {}", 
                user.getUserId(), notificationDataType);
    }
}