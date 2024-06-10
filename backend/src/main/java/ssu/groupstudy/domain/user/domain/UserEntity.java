package ssu.groupstudy.domain.user.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.auth.domain.Authority;
import ssu.groupstudy.domain.notification.domain.FcmToken;
import ssu.groupstudy.global.domain.BaseEntity;

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
public class UserEntity extends BaseEntity {
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
    private final List<Authority> roles = new ArrayList<>();

    @OneToMany(mappedBy = "user", fetch = LAZY, cascade = ALL, orphanRemoval = true)
    private final Set<FcmToken> fcmTokens = new HashSet<>();

    @Column(length = 20)
    private String statusMessage;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    @Column
    private String phoneModel;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public UserEntity(String name, String nickname, String phoneNumber, String password) {
        this.name = name;
        this.nickname = nickname;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.activateDate = LocalDateTime.now();
        this.deleteYn = 'N';
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
        roles.add(Authority.init(this));
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
        FcmToken newToken = FcmToken.from(this, token);
        return fcmTokens.contains(newToken);
    }

    public void addFcmToken(String token) {
        FcmToken newToken = FcmToken.from(this, token);
        fcmTokens.stream()
                .filter(fcmToken -> fcmToken.equals(newToken))
                .findFirst()
                .ifPresent(FcmToken::updateActivateDate);
        fcmTokens.add(newToken);
    }

    public List<String> getFcmTokenList() {
        return fcmTokens.stream()
                .map(FcmToken::getToken)
                .collect(Collectors.toList());
    }

    public void deleteFcmToken(String token) {
        FcmToken newToken = FcmToken.from(this, token);
        fcmTokens.remove(newToken);
    }

    public void editProfile(String nickname, String statusMessage) {
        this.nickname = nickname;
        this.statusMessage = statusMessage;
    }

    public void deleteUserInfo() {
        this.phoneNumber = "-";
        this.editProfile("-", "-");
        this.updatePicture(null);
        this.fcmTokens.clear();
        this.deleteYn = 'Y';
    }

    public boolean isDeleted() {
        return this.deleteYn == 'Y';
    }
}

