package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "사용자 API")
@CrossOrigin(maxAge = 3600) // Flutter cors 에러 해결
public class UserApi {
    private final UserService userService;

    @Operation(summary = "회원가입")
    @PostMapping("/register")
    public ResponseDto register(@Valid @RequestBody SignUpRequest dto) {
        Long userId = userService.signUp(dto);
        return DataResponseDto.of("userId", userId);
    }

    @Operation(summary = "id를 통한 사용자 조회")
    @GetMapping
    public ResponseDto getUser(@RequestParam Long userId) {
        UserInfoResponse user = userService.getUser(userId);
        return DataResponseDto.of("user", user);
    }

    @Operation(summary = "로그인")
    @PostMapping("/login")
    public ResponseDto login(@Valid @RequestBody SignInRequest request){
        SignInResponse signInResponse = userService.signIn(request);
        return DataResponseDto.of("loginUser", signInResponse);
    }
}
