package ssu.groupstudy.api.notification.vo;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import ssu.groupstudy.domain.notification.entity.NotificationHistoryEntity;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class NotificationHistoryResVo {
    
    private Long id;
    private String title;
    private String message;
    private Map<String, Object> data;
    private LocalDateTime createDate;
    
    public static NotificationHistoryResVo of(NotificationHistoryEntity entity) {
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> eventDataMap = new HashMap<>();
        
        try {
            eventDataMap = objectMapper.readValue(entity.getEventData(), new TypeReference<Map<String, Object>>() {});
        } catch (JsonProcessingException e) {
            log.warn("Failed to parse eventData JSON: {}", entity.getEventData(), e);
        }
        
        return new NotificationHistoryResVo(
            entity.getId(),
            entity.getTitle(),
            entity.getMessage(),
            eventDataMap,
            entity.getCreateDate()
        );
    }
}