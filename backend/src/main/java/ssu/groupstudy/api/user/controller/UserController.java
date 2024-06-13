package ssu.groupstudy.api.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.param.CustomUserDetails;
import ssu.groupstudy.api.user.vo.EditUserReqVo;
import ssu.groupstudy.api.user.vo.UserInfoResVo;
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
        final UserInfoResVo userInfo = UserInfoResVo.from(userDetails.getUser());
        return DataResVo.of("user", userInfo);
    }

    @Operation(summary = "사용자 프로필 편집", description = "사용자의 프로필 이미지가 변하지 않는 경우 null로 보내야 한다")
    @PatchMapping
    public ResVo editUser(@RequestPart("dto") EditUserReqVo dto,
                          @RequestPart(value = "profileImage", required = false) MultipartFile profileImage,
                          @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        final UserInfoResVo userInfo = userService.editUser(dto, profileImage, userDetails.getUser());
        return DataResVo.of("user", userInfo);
    }

    @Operation(summary = "사용자 탈퇴")
    @DeleteMapping
    public ResVo removeUser(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long userId = userService.removeUser(userDetails.getUser());
        return DataResVo.of("userId", userId);
    }

    @Operation(summary = "사용자가 활동한 시간을 갱신한다", description = "홈화면 갱신 시에 함께 호출된다")
    @PatchMapping("/activate-date")
    public ResVo updateActivateDate(@AuthenticationPrincipal CustomUserDetails userDetails) {
        userService.updateActivateDate(userDetails.getUser());
        return ResVo.success();
    }
}