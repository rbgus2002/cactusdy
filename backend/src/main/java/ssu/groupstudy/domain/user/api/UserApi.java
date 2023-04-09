package ssu.groupstudy.domain.user.api;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserSignUpService;

@RestController
@RequestMapping("/user")
@AllArgsConstructor
public class UserApi {
    private final UserSignUpService userSignUpService;
    @PostMapping("/signup")
    public User singUpTest(@RequestBody SignUpRequest dto){
        User user = userSignUpService.signUp(dto);
        return user;
    }
}
