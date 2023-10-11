package ssu.groupstudy.domain.user.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static javax.persistence.CascadeType.PERSIST;
import static javax.persistence.FetchType.EAGER;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String nickname;

    @Column
    private String picture;

    @Column(nullable = false, unique = true)
    private String phoneNumber;

    @Column(nullable = false)
    private String password;

    @OneToMany(mappedBy = "user", fetch = EAGER, cascade = PERSIST)
    private final List<Authority> roles = new ArrayList<>();

    @Column
    private String statusMessage;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    @Column
    private String phoneModel;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public User(String name, String nickname, String picture, String phoneModel, String phoneNumber, String password) {
        this.name = name;
        this.nickname = nickname;
        this.picture = picture;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.activateDate = LocalDateTime.now();
        this.phoneModel = phoneModel;
        this.deleteYn = 'N';
        this.statusMessage = "";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(userId, user.userId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }

    public void addUserRole(){
        roles.add(Authority.init(this));
    }

    public void updateActivateDate(){
        this.activateDate = LocalDateTime.now();
    }

    public void setStatusMessage(String statusMessage) {
        this.statusMessage = statusMessage;
    }
}

