package ssu.groupstudy.domain.round.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Embeddable
@Getter
@NoArgsConstructor
public class Appointment {
    @Column(length = 30)
    private String studyPlace;

    @Column
    private LocalDateTime studyTime;

    public static Appointment init(String studyPlace, LocalDateTime studyTime){
        return new Appointment(studyPlace, studyTime);
    }

    private Appointment(String studyPlace, LocalDateTime studyTime){
        this.studyPlace = studyPlace;
        this.studyTime = studyTime;
    }
}
