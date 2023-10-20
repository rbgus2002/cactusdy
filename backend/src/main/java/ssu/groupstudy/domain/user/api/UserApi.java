package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.auth.security.CustomUserDetails;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import java.io.IOException;

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
        UserInfoResponse userInfo = UserInfoResponse.from(userDetails.getUser());
        return DataResponseDto.of("user", userInfo);
    }

    @Operation(summary = "프로필 상태메세지 수정")
    @PutMapping("/profile/messages")
    public ResponseDto updateStatusMessage(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestBody StatusMessageRequest request){
        userService.updateStatusMessage(userDetails.getUser(), request);
        return ResponseDto.success();
    }

    @Operation(summary = "프로필 사진 업데이트")
    @PatchMapping("/profile/images")
    public ResponseDto updateProfileImage(@AuthenticationPrincipal CustomUserDetails userDetails, @RequestBody MultipartFile profileImage) throws IOException {
        userService.updateProfileImage(userDetails.getUser(), profileImage);
        return ResponseDto.success();
    }
}
