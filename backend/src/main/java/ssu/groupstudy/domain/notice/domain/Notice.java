package ssu.groupstudy.domain.notice.domain;


import lombok.*;
import org.hibernate.annotations.Where;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotParticipatedException;
import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.domain.BaseEntity;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private User writer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "studyId", nullable = false)
    private Study study;

    @OneToMany(mappedBy = "notice", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<CheckNotice> checkNotices = new HashSet<>();

    @Builder
    public Notice(String title, String contents, User writer, Study study) {
        this.title = title;
        this.contents = contents;
        this.writer = writer;
        this.study = study;
        this.deleteYn = 'N';
    }

    public String switchCheckNotice(CheckNotice checkNotice){
        checkUserInStudy(checkNotice);

        if(isAlreadyChecked(checkNotice)){
            uncheckNotice(checkNotice);
            return "Unchecked";
        }else{
            checkNotice(checkNotice);
            return "Checked";
        }
    }

    private void checkUserInStudy(CheckNotice checkNotice) {
        Study study = checkNotice.getNotice().getStudy();
        if(!study.isParticipated(checkNotice.getUser())){
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
    }

    private boolean isAlreadyChecked(CheckNotice checkNotice){
        return checkNotices.contains(checkNotice);
    }

    private void uncheckNotice(CheckNotice checkNotice){
        checkNotices.remove(checkNotice);
    }

    private void checkNotice(CheckNotice checkNotice){
        checkNotices.add(checkNotice);
    }

    @Override
    public String toString() {
        return "Notice{" +
                "noticeId=" + noticeId +
                ", title='" + title + '\'' +
                ", contents='" + contents + '\'' +
                ", deleteYn=" + deleteYn +
                ", writer=" + writer +
                ", study=" + study +
                ", checkNotices=" + checkNotices +
                '}';
    }
}