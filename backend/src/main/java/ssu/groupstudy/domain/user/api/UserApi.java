package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "User", description = "사용자 API")
@CrossOrigin(maxAge = 3600) // TODO : 삭제 여부 검토 (Flutter cors 에러 해결)
public class UserApi {
    private final UserService userService;

    @Operation(summary = "id를 통한 사용자 조회")
    @GetMapping
    public ResponseDto getUser(@RequestParam Long userId) {
        UserInfoResponse user = userService.getUser(userId);
        return DataResponseDto.of("user", user);
    }
}
