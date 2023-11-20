package ssu.groupstudy.domain.round.domain;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Embeddable
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Appointment {
    @Column(length = 30)
    private String studyPlace;
    @Column
    private LocalDateTime studyTime;

    public static Appointment of(String studyPlace, LocalDateTime studyTime){
        return new Appointment(studyPlace, studyTime);
    }

    public static Appointment empty(){
        return new Appointment();
    }
}
