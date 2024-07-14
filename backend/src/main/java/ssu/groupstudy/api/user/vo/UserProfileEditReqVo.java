package ssu.groupstudy.api.user.vo;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class UserProfileEditReqVo {
    private String nickname;
    private String statusMessage;
}
