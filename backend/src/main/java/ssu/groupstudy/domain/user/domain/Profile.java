package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
public class Profile {
    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String nickName;

    private String picture;
    private String statusMessage;
    private String email;

    @Builder
    public Profile(String name, String nickName, String picture, String statusMessage, String email) {
        this.name = name;
        this.nickName = nickName;
        this.picture = picture;
        this.statusMessage = statusMessage;
        this.email = email;
    }
}
