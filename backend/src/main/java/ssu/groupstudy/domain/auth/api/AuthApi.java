package ssu.groupstudy.domain.auth.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.dto.request.MessageRequest;
import ssu.groupstudy.domain.auth.dto.request.PasswordResetRequest;
import ssu.groupstudy.domain.auth.dto.request.VerifyRequest;
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
// TODO : AuthAPI는 인증가 필터 안타도록 처리 필요함 (불필요한 query)
public class AuthApi {
    private final AuthService authService;

    @Operation(summary = "로그인", description = "로그인 시에 토큰을 발급한다.")
    @PostMapping("/signIn")
    public ResponseDto signIn(@Valid @RequestBody SignInRequest request) {
        SignInResponse signInResponse = authService.signIn(request);
        return DataResponseDto.of("loginUser", signInResponse);
    }

    @Operation(summary = "회원가입")
    @PostMapping("/signUp")
    public ResponseDto signUp(@Valid @RequestBody SignUpRequest dto) {
        Long userId = authService.signUp(dto);
        return DataResponseDto.of("userId", userId);
    }

    @Operation(summary = "회원가입 인증코드 문자 전송", description = "문자 메세지로 회원가입 인증코드를 전송한다. (발신번호 : 01044992038)")
    @PostMapping("/signUp/send")
    public ResponseDto sendMessageToSignUp(@Valid @RequestBody MessageRequest request) {
        authService.sendMessageToSignUp(request);
        return DataResponseDto.success();
    }

    @Operation(summary = "인증코드 검증", description = "발급받은 인증번호가 올바른지 검사한다.")
    @PostMapping("/verify")
    public ResponseDto verifyCode(@Valid @RequestBody VerifyRequest request) {
        boolean isSuccess = authService.verifyCode(request);
        return DataResponseDto.of("isSuccess", isSuccess);
    }

    @Operation(summary = "비밀번호 재설정", description = "비밀번호를 잊어버린 경우, 휴대전화로 비밀번호를 재설정한다.")
    @PutMapping("/passwords")
    public ResponseDto resetPassword(@Valid @RequestBody PasswordResetRequest request) {
        authService.resetPassword(request);
        return DataResponseDto.success();
    }

    @Operation(summary = "비밀번호 재설정 인증코드 문자 전송", description = "문자 메세지로 비밀번호 재설정 인증코드를 전송한다. (발신번호 : 01044992038)")
    @PostMapping("/passwords/send")
    public ResponseDto sendMessageToResetPassword(@Valid @RequestBody MessageRequest request) {
        authService.sendMessageToResetPassword(request);
        return DataResponseDto.success();
    }
}

