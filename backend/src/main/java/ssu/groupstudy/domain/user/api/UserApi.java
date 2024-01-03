package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.user.dto.request.EditUserRequest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import java.io.IOException;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "사용자 API")
public class UserApi {
    private final UserService userService;

    @Operation(summary = "사용자 조회")
    @GetMapping
    public ResponseDto getUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        final UserInfoResponse userInfo = UserInfoResponse.from(userDetails.getUser());
        return DataResponseDto.of("user", userInfo);
    }

    @Operation(summary = "사용자 프로필 편집", description = "사용자의 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping
    public ResponseDto editUser(@RequestPart("dto") EditUserRequest dto,
                                @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final UserInfoResponse userInfo = userService.editUser(dto, profileImage, userDetails.getUser());
        return DataResponseDto.of("user", userInfo);
    }

    @Operation(summary = "사용자 탈퇴")
    @DeleteMapping
    public ResponseDto deleteUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userService.deleteUser(userDetails.getUser());
        return DataResponseDto.of("userId", userId);
    }
}