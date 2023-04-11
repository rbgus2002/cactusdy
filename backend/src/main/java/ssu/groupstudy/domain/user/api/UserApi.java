package ssu.groupstudy.domain.user.api;

import jakarta.validation.Valid;
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
    @PostMapping("/register")
    public Long register(@Valid @RequestBody SignUpRequest dto){
        Long longId = userSignUpService.signUp(dto);
        return longId;
    }
}
