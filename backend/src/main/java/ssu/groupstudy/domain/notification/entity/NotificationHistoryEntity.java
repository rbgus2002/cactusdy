package ssu.groupstudy.domain.notification.entity;

import lombok.*;
import ssu.groupstudy.domain.common.entity.BaseEntity;
import ssu.groupstudy.domain.common.enums.AlarmType;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.persistence.*;

import static javax.persistence.EnumType.STRING;
import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@ToString
@Table(name = "notification_history", indexes = {
        @Index(name = "idx_user_id_create_date", columnList = "user_id, createDate DESC")
})
public class NotificationHistoryEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(nullable = false, length = 50)
    @Enumerated(STRING)
    private AlarmType alarmType;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    @Column(nullable = false, columnDefinition = "JSON")
    private String eventData;

    @Builder
    public NotificationHistoryEntity(UserEntity user, AlarmType alarmType, String title, 
                                   String message, String eventData) {
        this.user = user;
        this.alarmType = alarmType;
        this.title = title;
        this.message = message;
        this.eventData = eventData;
    }
}