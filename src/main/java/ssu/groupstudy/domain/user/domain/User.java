package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import ssu.groupstudy.global.domain.BaseEntity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
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

    @Builder
    public User(String name, String nickName) {
        this.activateDate = LocalDateTime.now();
        this.deleteYn = 'N';
    }
}

