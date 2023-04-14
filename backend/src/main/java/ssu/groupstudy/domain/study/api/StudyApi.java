package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.RegisterStudyRequest;
import ssu.groupstudy.domain.study.service.StudyCreateService;
import ssu.groupstudy.global.dto.DataResponseDto;

@RestController
@RequestMapping("/study")
@AllArgsConstructor
@Tag(name = "Study", description = "스터디 API")
public class StudyApi {
    private final StudyCreateService studyCreateService;

    @Operation(summary = "새로운 스터디 생성")
    @PostMapping("/register")
    public DataResponseDto registerStudy(@Valid @RequestBody RegisterStudyRequest dto){
        Study newStudy = studyCreateService.createNewStudy(dto);

        return DataResponseDto.of("study", newStudy);
    }
}






//public class UserApi {
//    private final UserSignUpService userSignUpService;
//
//    @Operation(summary = "회원가입")
//    @Parameter(name = "test", description = "??????")
//    @PostMapping("/register")
//    public DataResponseDto register(@Valid @RequestBody SignUpRequest dto){
//        User user = userSignUpService.signUp(dto);
//        return DataResponseDto.of("user", user);
//    }
//}
