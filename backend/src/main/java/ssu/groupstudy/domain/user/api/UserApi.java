package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "사용자 API")
@CrossOrigin(maxAge = 3600) // TODO : 삭제 여부 검토 (Flutter cors 에러 해결)
public class UserApi {
    private final UserService userService;

    @Operation(summary = "사용자 조회")
    @GetMapping
    public ResponseDto getUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        return DataResponseDto.of("user", UserInfoResponse.from(userDetails.getUser()));
    }
}
