package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import ssu.groupstudy.global.domain.BaseEntity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Embedded
    private Profile profile;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    private String phoneModel;

    @Column(nullable = false)
    private char deleteYn;

    // TODO : 방장 여부 추가

    @Builder
    public User(String name, String nickName, String picture, String phoneModel, String email) {
        this.profile = Profile.builder()
                .name(name)
                .nickName(nickName)
                .picture(picture)
                .email(email)
                .build();
        this.activateDate = LocalDateTime.now();
        this.phoneModel = phoneModel;
        this.deleteYn = 'N';
    }
}

