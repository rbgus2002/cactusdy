package ssu.groupstudy.domain.user.domain;

import lombok.*;
import org.hibernate.annotations.Where;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.time.LocalDateTime;


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
    private String nickname;

    @Column
    private String picture;

    @Column
    private String statusMessage;
    
    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private LocalDateTime activateDate;

    private String phoneModel;

    @Column(nullable = false)
    private char deleteYn;

    @Builder
    public User(String name, String nickname, String picture, String phoneModel, String email) {
        this.name = name;
        this.nickname = nickname;
        this.picture = picture;
        this.email = email;
        this.activateDate = LocalDateTime.now();
        this.phoneModel = phoneModel;
        this.deleteYn = 'N';
        this.statusMessage = "";
    }
}

