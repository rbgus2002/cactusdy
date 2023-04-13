package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
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
