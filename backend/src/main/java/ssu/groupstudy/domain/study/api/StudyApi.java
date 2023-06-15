package ssu.groupstudy.domain.study.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.dto.reuqest.CreateStudyRequest;
import ssu.groupstudy.domain.study.service.StudyCreateService;
import ssu.groupstudy.domain.study.service.StudyInviteService;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.dto.DataResponseDto;
import ssu.groupstudy.global.dto.ResponseDto;

import javax.validation.Valid;

@RestController
@RequestMapping("/study")
@AllArgsConstructor
@Tag(name = "Study", description = "스터디 API")
public class StudyApi {
    private final StudyCreateService studyCreateService;

    @Operation(summary = "새로운 스터디 생성")
    @PostMapping("")
    public ResponseDto register(@Valid @RequestBody CreateStudyRequest dto){
        Long studyId = studyCreateService.createStudy(dto);

        return DataResponseDto.of("studyId", studyId);
    }
}