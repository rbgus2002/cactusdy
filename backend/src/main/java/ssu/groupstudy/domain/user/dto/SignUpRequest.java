package ssu.groupstudy.domain.user.dto;

import lombok.AllArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;


@AllArgsConstructor
public class SignUpRequest {
    String name;
    String nickName;

    public User toEntity(){
        return new User(name, nickName);
    }
}
