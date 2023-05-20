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
@AllArgsConstructor
public class Appointment {
    @Column(length = 30)
    private String studyPlace;

    @Column
    private LocalDateTime studyTime;

    public static Appointment init(String studyPlace, LocalDateTime studyTime){
        return new Appointment(studyPlace, studyTime);
    }

    // TODO : 스터디 예정 시간 계산 하는 로직은 해당 객체에게 책임 부여하기
}
