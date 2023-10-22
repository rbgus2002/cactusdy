package ssu.groupstudy.domain.round.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import ssu.groupstudy.domain.round.domain.Appointment;
import ssu.groupstudy.domain.round.domain.Round;
import ssu.groupstudy.domain.study.domain.Study;

import java.time.LocalDateTime;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class AppointmentRequest {
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm", timezone = "Asia/Seoul")
    private LocalDateTime studyTime;
    private String studyPlace;

    public Round toEntity(Study study) {
        return Round.builder()
                .study(study)
                .studyPlace(this.studyPlace)
                .studyTime(studyTime)
                .build();
    }

    public Appointment toAppointment(){
        return new Appointment(this.studyPlace, this.studyTime);
    }
}
