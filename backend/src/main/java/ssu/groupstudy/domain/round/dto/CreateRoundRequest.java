package ssu.groupstudy.domain.round.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateRoundRequest {
    @NotNull
    private Long studyId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime studyTime;
    private String studyPlace; // TODO : 추후 카카오톡 주소 api 연동?

    public Round toEntity(Study study) {
        return Round.builder()
                .study(study)
                .studyPlace(this.studyPlace)
                .studyTime(studyTime)
                .build();
    }

    public CreateRoundRequest(Long studyId) {
        this.studyId = studyId;
    }
}
