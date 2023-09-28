package ssu.groupstudy.domain.user.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Authority {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "authority_id")
    private Long id;

    @Column(name = "role_name", nullable = false)
    private String name;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name="userId", nullable = false)
    @JsonIgnore
    private User user;

    private Authority(String name, User user) {
        this.name = name;
        this.user = user;
    }

    public static Authority init(User user){
        return new Authority("ROLE_USER", user);
    }
}
