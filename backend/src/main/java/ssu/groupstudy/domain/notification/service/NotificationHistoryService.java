package ssu.groupstudy.domain.notification.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.api.notification.vo.NotificationHistoryPageResVo;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;
import ssu.groupstudy.domain.notification.repository.NotificationHistoryEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;

import java.util.Map;

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
}