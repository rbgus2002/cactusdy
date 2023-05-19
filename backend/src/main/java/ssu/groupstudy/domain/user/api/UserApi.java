package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/user")
@AllArgsConstructor
@Tag(name = "User", description = "사용자 API")
@CrossOrigin(maxAge = 3600) // Flutter cors 에러 해결
public class UserApi {
    private final UserService userService;

    @Operation(summary = "회원가입")
    @PostMapping("")
    public ResponseDto registerUser(@Valid @RequestBody SignUpRequest dto) {
        userService.signUp(dto);
        return ResponseDto.success();
    }

    @Operation(summary = "id를 통한 사용자 조회")
    @GetMapping("")
    public ResponseDto findUser(@RequestParam Long userId) {
        UserInfoResponse user = userService.getUser(userId);
        return DataResponseDto.of("user", user);
    }

    // TODO : swagger에 api별로 response 형식 명시
    // TODO : return type 모두 ResponseDto로 변경
}
