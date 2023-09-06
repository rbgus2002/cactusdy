package ssu.groupstudy.domain.round.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.time.LocalDateTime;

@Embeddable
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Appointment {
    @Column(length = 30)
    private String studyPlace;
    @Column
    private LocalDateTime studyTime;
}
