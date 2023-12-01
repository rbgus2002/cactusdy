package ssu.groupstudy.domain.user.dto.request;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class EditUserRequest {
    private String nickname;
    private String statusMessage;
}
