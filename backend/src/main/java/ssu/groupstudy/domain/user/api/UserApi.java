package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "User", description = "사용자 API")
public class UserApi {
    private final UserSignUpService userSignUpService;

    @Operation(summary = "회원가입")
    @Parameter(name = "test", description = "??????")
    @PostMapping("/register")
    public DataResponseDto register(@Valid @RequestBody SignUpRequest dto){
        User user = userSignUpService.signUp(dto);
        return DataResponseDto.of("user", user);
    }
}
