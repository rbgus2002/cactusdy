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

import static javax.persistence.CascadeType.*;
import static javax.persistence.FetchType.EAGER;
import static javax.persistence.FetchType.LAZY;

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

    @Column(nullable = false)
    private char pinYn;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private User writer;

    @ManyToOne(fetch = EAGER) // EAGER 필수 (this.study issue 관련)
    @JoinColumn(name = "studyId", nullable = false)
    private Study study;

    @OneToMany(mappedBy = "notice", cascade = ALL, orphanRemoval = true)
    private Set<CheckNotice> checkNotices = new HashSet<>();

    @Builder
    public Notice(String title, String contents, User writer, Study study) {
        validateUserInStudy(study, writer);

        this.title = title;
        this.contents = contents;
        this.writer = writer;
        this.study = study;
        this.deleteYn = 'N';
        this.pinYn = 'N';
    }

    public Character switchCheckNotice(User user){
        validateUserInStudy(this.study, user);
        return isRead(user) ? unreadNotice(user) : readNotice(user);
    }

    public char switchPin(){
        if(pinYn == 'N'){
            pin();
        }else{
            unpin();
        }
        return this.pinYn;
    }

    private void pin(){
        pinYn = 'Y';
    }

    private void unpin(){
        pinYn = 'N';
    }

    private void validateUserInStudy(Study study, User user) {
        if(!study.isParticipated(user)){
            throw new UserNotParticipatedException(ResultCode.USER_NOT_PARTICIPATED);
        }
    }

    public boolean isRead(User user){
        return checkNotices.contains(new CheckNotice(this, user));
    }

    /**
     * 공지사항을 읽지 않은 사용자를 읽음 처리한다
     */
    private Character readNotice(User user){
        checkNotices.add(new CheckNotice(this, user));
        return 'Y';
    }

    /**
     * 공지사항을 읽은 사용자를 안읽음 처리한다
     */
    private Character unreadNotice(User user){
        checkNotices.remove(new CheckNotice(this, user));
        return 'N';
    }

    public void deleteNotice(){
        this.deleteYn = 'Y';
    }
}