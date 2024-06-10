package ssu.groupstudy.domain.user.entity;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.auth.entity.AuthorityEntity;
import ssu.groupstudy.domain.common.entity.BaseWithSoftDeleteEntity;
import ssu.groupstudy.domain.notification.entity.FcmTokenEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static javax.persistence.CascadeType.ALL;
import static javax.persistence.CascadeType.PERSIST;
import static javax.persistence.FetchType.LAZY;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "user")
public class UserEntity extends BaseWithSoftDeleteEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 6)
    private String nickname;

    @Column
    private String picture;

    @Column(nullable = false)
    private String phoneNumber;

    @Column(nullable = false)
    private String password;

    @OneToMany(mappedBy = "user", fetch = LAZY, cascade = PERSIST)
    private final List<AuthorityEntity> roles = new ArrayList<>();

    @OneToMany(mappedBy = "user", fetch = LAZY, cascade = ALL, orphanRemoval = true)
    private final Set<FcmTokenEntity> fcmTokens = new HashSet<>();

    @Column(length = 20)
    private String statusMessage;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    @Column
    private String phoneModel;

    @Builder
    public UserEntity(String name, String nickname, String phoneNumber, String password) {
        this.name = name;
        this.nickname = nickname;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.activateDate = LocalDateTime.now();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof UserEntity)) {
            return false;
        }
        UserEntity that = (UserEntity) o;
        return Objects.equals(this.userId, that.getUserId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.userId);
    }

    @Override
    public String toString() {
        return "UserEntity{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                '}';
    }

    public void addUserRole() {
        roles.add(AuthorityEntity.init(this));
    }

    public void updateActivateDate() {
        this.activateDate = LocalDateTime.now();
    }

    public void updatePicture(String picture) {
        this.picture = picture;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean existFcmToken(String token) {
        FcmTokenEntity newToken = FcmTokenEntity.from(this, token);
        return fcmTokens.contains(newToken);
    }

    public void addFcmToken(String token) {
        FcmTokenEntity newToken = FcmTokenEntity.from(this, token);
        fcmTokens.stream()
                .filter(fcmToken -> fcmToken.equals(newToken))
                .findFirst()
                .ifPresent(FcmTokenEntity::updateActivateDate);
        fcmTokens.add(newToken);
    }

    public List<String> getFcmTokenList() {
        return fcmTokens.stream()
                .map(FcmTokenEntity::getToken)
                .collect(Collectors.toList());
    }

    public void deleteFcmToken(String token) {
        FcmTokenEntity newToken = FcmTokenEntity.from(this, token);
        fcmTokens.remove(newToken);
    }

    public void editProfile(String nickname, String statusMessage) {
        this.nickname = nickname;
        this.statusMessage = statusMessage;
    }

    public void deleteUser() {
        this.phoneNumber = "-";
        this.editProfile("-", "-");
        this.updatePicture(null);
        this.fcmTokens.clear();
        delete();
    }
}

