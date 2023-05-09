package ssu.groupstudy.domain.user.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.UserResponse;
import ssu.groupstudy.domain.user.service.UserService;
import ssu.groupstudy.global.dto.DataResponseDto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/user")
@AllArgsConstructor
@Tag(name = "User", description = "사용자 API")
@CrossOrigin(maxAge = 3600) // Flutter cors 에러 해결
public class UserApi {
    private final UserService userService;

    @Operation(summary = "회원가입")
    @PostMapping("")
    public DataResponseDto registerUser(@Valid @RequestBody SignUpRequest dto){
        User user = userService.signUp(dto);
        return DataResponseDto.of("user", user);
    }

    @Operation(summary = "id를 통한 사용자 조회")
    @GetMapping("")
    public DataResponseDto findUser(@RequestParam Long userId){
        UserResponse user = userService.getUser(userId);
        return DataResponseDto.of("user", user);
    }

    // TODO : swagger에 api별로 response 형식 명시
}
