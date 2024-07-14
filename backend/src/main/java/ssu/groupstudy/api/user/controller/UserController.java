package ssu.groupstudy.api.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.api.user.vo.UserProfileEditReqVo;
import ssu.groupstudy.api.user.vo.UserInfoResVo;
import ssu.groupstudy.domain.user.param.UserParam;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import java.io.IOException;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@Tag(name = "UserEntity", description = "사용자 API")
public class UserController {
    private final UserService userService;

    @Operation(summary = "사용자 조회")
    @GetMapping
    public ResVo getUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        UserParam user = userDetails.toUserParam();
        UserInfoResVo userInfo = UserInfoResVo.from(user);
        return DataResVo.of("user", userInfo);
    }

    @Operation(summary = "사용자 프로필 편집", description = "사용자의 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping
    @Deprecated // [2024-07-14:최규현] TODO: FE에서 교체 후 삭제 예정
    public ResVo editUserDeprecatedVersion(@RequestPart("dto") UserProfileEditReqVo dto,
                                           @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                                           @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        UserParam user = userService.editUser(userDetails.getUser().getUserId(), dto.getNickname(), dto.getStatusMessage(), profileImage);
        return DataResVo.of("user", UserInfoResVo.from(user));
    }

    @Operation(summary = "사용자 프로필 편집", description = "사용자의 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping("/{userId}")
    public ResVo editUser(
            @PathVariable Long userId,
            @RequestParam String nickname,
            @RequestParam String statusMessage,
            @RequestPart(value = "profileImage", required = false) MultipartFile profileImage
    ) throws IOException {
        UserParam user = userService.editUser(userId, nickname, statusMessage, profileImage);
        return DataResVo.of("user", UserInfoResVo.from(user));
    }

    @Operation(summary = "사용자 탈퇴")
    @DeleteMapping
    @Deprecated
    public ResVo removeUser(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        userService.removeUser(userDetails.getUser().getUserId());
        return DataResVo.of("userId", userDetails.getUser().getUserId());
    }

    @Operation(summary = "사용자 탈퇴")
    @DeleteMapping("/{userId}")
    public ResVo removeUser(
            @PathVariable Long userId
    ) {
        userService.removeUser(userId);
        return DataResVo.of("userId", userId);
    }

    @Operation(summary = "사용자 활동시간 갱신", description = "홈화면 갱신 시에 함께 호출된다")
    @PatchMapping("/activate-date")
    @Deprecated
    public ResVo updateActivateDate(
            @AuthenticationPrincipal CustomUserDetails userDetails
    ) {
        userService.updateActivateDate(userDetails.getUser().getUserId());
        return ResVo.success();
    }

    @Operation(summary = "사용자가 활동한 시간을 갱신한다", description = "홈화면 갱신 시에 함께 호출된다")
    @PatchMapping("/{userId}/activate-date")
    public ResVo updateActivateDate(
            @PathVariable Long userId
    ) {
        userService.updateActivateDate(userId);
        return ResVo.success();
    }

}