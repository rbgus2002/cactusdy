package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.Column;
import lombok.*;

@Builder
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Profile {
    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String nickName;

    private String picture;
    private String statusMessage;
    private String email;
}
