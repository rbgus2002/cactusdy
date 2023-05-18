package ssu.groupstudy.domain.notice.domain;


import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Where(clause = "delete_yn = 'N'")
public class Notice extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @Column(nullable = false, length = 50)
    private String title;

    @Column(nullable = false, length = 100)
    private String contents;

    @Column(nullable = false)
    private char deleteYn;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User writer;

    @ManyToOne
    @JoinColumn(name="studyId", nullable = false)
    private Study study;

    @Builder
    public Notice(String title, String contents, User writer, Study study) {
        this.title = title;
        this.contents = contents;
        this.writer = writer;
        this.study = study;
        this.deleteYn = 'N';
    }
}