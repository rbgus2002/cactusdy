package ssu.groupstudy.domain.user.api;

import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserSignUpService;
import ssu.groupstudy.global.dto.DataResponseDto;

import java.util.Map;

@RestController
@RequestMapping("/user")
@AllArgsConstructor
public class UserApi {
    private final UserSignUpService userSignUpService;
    @PostMapping("/register")
    public DataResponseDto register(@Valid @RequestBody SignUpRequest dto){
        User user = userSignUpService.signUp(dto);
        return DataResponseDto.of("user", user);
    }
}
