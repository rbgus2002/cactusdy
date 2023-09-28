package ssu.groupstudy.domain.auth.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.auth.service.AuthService;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Auth", description = "인증 API")
public class AuthApi {
    private final AuthService authService;

    @Operation(summary = "회원가입")
    @PostMapping("/signUp")
    public ResponseDto signUp(@Valid @RequestBody SignUpRequest dto) {
        Long userId = authService.signUp(dto);
        return DataResponseDto.of("userId", userId);
    }

    @Operation(summary = "로그인", description = "로그인 시에 토큰을 발급한다.")
    @PostMapping("/signIn")
    public ResponseDto signIn(@Valid @RequestBody SignInRequest request){
        SignInResponse signInResponse = authService.signIn(request);
        return DataResponseDto.of("loginUser", signInResponse);
    }
}

