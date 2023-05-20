package ssu.groupstudy.domain.user.domain;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.Where;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Where(clause = "delete_yn = 'N'")
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String nickName;

    private String picture;
    private String statusMessage;
    
    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    private String phoneModel;

    @Column(nullable = false)
    @ColumnDefault("N")
    private char deleteYn;

    @Builder
    public User(String name, String nickName, String picture, String phoneModel, String email) {
        this.name = name;
        this.nickName = nickName;
        this.picture = picture;
        this.email = email;
        this.activateDate = LocalDateTime.now();
        this.phoneModel = phoneModel;
        this.deleteYn = 'N';
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", nickName='" + nickName + '\'' +
                ", picture='" + picture + '\'' +
                ", statusMessage='" + statusMessage + '\'' +
                ", email='" + email + '\'' +
                ", activateDate=" + activateDate +
                ", phoneModel='" + phoneModel + '\'' +
                ", deleteYn=" + deleteYn +
                '}';
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
}

