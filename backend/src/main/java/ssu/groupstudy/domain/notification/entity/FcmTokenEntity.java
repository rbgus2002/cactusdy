package ssu.groupstudy.domain.notification.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.common.entity.BaseEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

import static javax.persistence.FetchType.LAZY;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "fcm_token")
public class FcmTokenEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fcm_token_id")
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="user_id", nullable = false)
    @JsonIgnore
    private UserEntity user;

    @Column(nullable = false)
    private String token;

    @Column(nullable = false)
    private LocalDateTime activateDate;


    private FcmTokenEntity(UserEntity user, String token) {
        this.user = user;
        this.token = token;
        this.activateDate = LocalDateTime.now();
    }

    public static FcmTokenEntity from(UserEntity user, String token){
        return new FcmTokenEntity(user, token);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o){
            return true;
        }
        if (!(o instanceof FcmTokenEntity)) {
            return false;
        }
        FcmTokenEntity that = (FcmTokenEntity) o;
        return Objects.equals(this.token, that.getToken());
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.token);
    }

    public void updateActivateDate(){
        this.activateDate = LocalDateTime.now();
    }

    public boolean isExpired(){
        return this.activateDate.isBefore(LocalDateTime.now().minusDays(35));
    }
}
