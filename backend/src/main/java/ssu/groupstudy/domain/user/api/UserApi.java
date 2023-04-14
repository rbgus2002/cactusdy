package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;


@RestController
@RequestMapping("/user")
@AllArgsConstructor
@Tag(name = "User", description = "사용자 API")
public class UserApi {
    private final UserService userService;

    @Operation(summary = "회원가입")
    @Parameter(name = "test", description = "??????")
    @PostMapping("/register")
    public DataResponseDto register(@Valid @RequestBody SignUpRequest dto){
        User user = userService.signUp(dto);
        return DataResponseDto.of("user", user);
    }
}
