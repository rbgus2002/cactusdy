package ssu.groupstudy.domain.user.api;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.service.UserSignUpService;
import ssu.groupstudy.global.dto.DataResponseDto;

@RestController
@RequestMapping("/user")
@AllArgsConstructor
@Tag(name = "User", description = "사용자 API")
public class UserApi {
    private final UserSignUpService userSignUpService;

    @Operation(summary = "회원가입")
    @Parameter(name = "test", description = "??????")
    @PostMapping("/register")
    public DataResponseDto register(@Valid @RequestBody SignUpRequest dto){
        User user = userSignUpService.signUp(dto);
        return DataResponseDto.of("user", user);
    }
}
