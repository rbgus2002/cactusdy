package ssu.groupstudy.domain.user.domain;

import jakarta.persistence.Column;

public class Profile {
    @Column(nullable = false)
    private String name;

    @Column(nullable = false, length = 10)
    private String nickName;

    private String picture;

    private String statusMessage;
}
