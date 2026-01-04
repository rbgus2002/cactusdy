package ssu.groupstudy.domain.notification.entity;

import lombok.*;
import ssu.groupstudy.domain.common.entity.BaseEntity;
import ssu.groupstudy.domain.common.enums.NotificationDataType;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.global.config.converter.YNBooleanConverter;

import javax.persistence.*;

import static javax.persistence.EnumType.STRING;
import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@ToString
@Table(name = "notification_history")
public class NotificationHistoryEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(nullable = false, length = 50, name = "alarm_type")
    @Enumerated(STRING)
    private NotificationDataType notificationDataType;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    @Column(nullable = false, columnDefinition = "JSON")
    private String eventData;

    @Convert(converter = YNBooleanConverter.class)
    @Column(nullable = false, length = 1, name = "is_read")
    private Boolean isRead;

    @Builder
    public NotificationHistoryEntity(UserEntity user, NotificationDataType notificationDataType,
                                   String title, String message, String eventData, Boolean isRead) {
        this.user = user;
        this.notificationDataType = notificationDataType;
        this.title = title;
        this.message = message;
        this.eventData = eventData;
        this.isRead = isRead != null && isRead;
    }

    public void markRead() {
        this.isRead = true;
    }
}
