package ssu.groupstudy.domain.study.entity;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.exception.InvalidColorException;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.ColorCode;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.entity.BaseEntity;

import javax.persistence.*;
import java.util.Objects;

import static javax.persistence.FetchType.LAZY;


@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "rel_user_study")
@Getter
public class ParticipantEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_study_id")
    private Long id;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private UserEntity user;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "studyId", nullable = false)
    private StudyEntity study;

    @Column(nullable = false)
    private String color;

    public ParticipantEntity(UserEntity user, StudyEntity study) {
        this.user = user;
        this.study = study;
        this.color = ColorCode.DEFAULT.getHex();
    }

    public static ParticipantEntity createWithColor(UserEntity user, StudyEntity study, String color) {
        ParticipantEntity participant = new ParticipantEntity(user, study);
        participant.setColor(color);
        return participant;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ParticipantEntity)) {
            return false;
        }
        ParticipantEntity that = (ParticipantEntity) o;
        return Objects.equals(this.user.getUserId(), that.getUser().getUserId()) && Objects.equals(this.study.getStudyId(), that.getStudy().getStudyId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(user.getUserId(), study.getStudyId());
    }

    public void setColor(String color) {
        validateHex(color);
        this.color = color;
    }

    private void validateHex(String color) {
        boolean isHex = color.matches("^(0[xX])?[0-9a-fA-F]+$");
        if (!isHex) {
            throw new InvalidColorException(ResultCode.INVALID_COLOR);
        }
    }
}
