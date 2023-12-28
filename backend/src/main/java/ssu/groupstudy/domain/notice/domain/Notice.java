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
import java.util.HashSet;
import java.util.Set;

import static javax.persistence.CascadeType.ALL;
import static javax.persistence.FetchType.LAZY;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "notice")
@Where(clause = "delete_yn = 'N'")
public class Notice extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long noticeId;

    @Column(nullable = false, length = 50)
    private String title;

    @Column(nullable = false, length = 500)
    private String contents;

    @Column(nullable = false)
    private char deleteYn;

    @Column(nullable = false)
    private char pinYn;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private User writer;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "studyId", nullable = false)
    private Study study;

    @OneToMany(mappedBy = "notice", cascade = ALL, orphanRemoval = true)
    private final Set<CheckNotice> checkNotices = new HashSet<>();

    @Builder
    public Notice(String title, String contents, User writer, Study study) {
        this.title = title;
        this.contents = contents;
        this.writer = writer;
        this.study = study;
        this.deleteYn = 'N';
        this.pinYn = 'N';
    }

    public Character switchCheckNotice(User user){
        return isRead(user) ? unreadNotice(user) : readNotice(user);
    }

    public boolean isRead(User user){
        return checkNotices.contains(new CheckNotice(this, user));
    }

    /**
     * 공지사항을 읽은 사용자를 안읽음 처리한다
     */
    private Character unreadNotice(User user){
        checkNotices.remove(new CheckNotice(this, user));
        return 'N';
    }

    /**
     * 공지사항을 읽지 않은 사용자를 읽음 처리한다
     */
    private Character readNotice(User user){
        checkNotices.add(new CheckNotice(this, user));
        return 'Y';
    }

    public char switchPin(){
        return (pinYn == 'N') ? pin() : unpin();
    }

    private char pin(){
        pinYn = 'Y';
        return pinYn;
    }

    private char unpin(){
        pinYn = 'N';
        return pinYn;
    }

    public void deleteNotice(){
        this.deleteYn = 'Y';
    }

    public int countReadNotices(){
        return this.checkNotices.size();
    }

    public void updateTitleAndContents(String title, String contents) {
        this.title = title;
        this.contents = contents;
    }
}