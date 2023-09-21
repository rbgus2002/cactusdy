package ssu.groupstudy.domain.login.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.login.service.LoginService;
import ssu.groupstudy.domain.user.dto.request.SignInRequest;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.SignInResponse;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping
@RequiredArgsConstructor
@Tag(name = "Login", description = "로그인 API")
public class LoginApi {
    private final LoginService loginService;

    @Operation(summary = "회원가입")
    @PostMapping("/register")
    public ResponseDto register(@Valid @RequestBody SignUpRequest dto) {
        Long userId = loginService.signUp(dto);
        return DataResponseDto.of("userId", userId);
    }

    @Operation(summary = "로그인")
    @PostMapping("/login")
    public ResponseDto login(@Valid @RequestBody SignInRequest request){
        SignInResponse signInResponse = loginService.signIn(request);
        return DataResponseDto.of("loginUser", signInResponse);
    }
}

