package ssu.groupstudy.domain.notification.domain;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;

@Getter
@RequiredArgsConstructor
public class SignInSuccessEvent {
    private final User user;
}
