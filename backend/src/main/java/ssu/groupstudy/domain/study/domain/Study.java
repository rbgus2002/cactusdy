package ssu.groupstudy.domain.study.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;
import ssu.groupstudy.global.ResultCode;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Study extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long studyId;

    @Column(nullable = false, length = 30)
    private String studyName;

    @Column(length = 40)
    private String detail;

    private String picture;

    @Column(nullable = false)
    private String inviteLink;

    @Column(nullable = false)
    private String inviteQrCode;

    @ManyToOne
    @JoinColumn(name="userId", nullable = false)
    private User hostUser;

    @Column(nullable = false)
    private char deleteYn;

    @Builder 
    public Study(String studyName, String detail, String picture, User hostUser) {
        this.studyName = studyName;
        this.detail = detail;
        this.picture = picture;
        this.hostUser = hostUser;
        // TODO : 직접 안넣어줘도 default로 들어가게 추후 수정
        this.deleteYn = 'N';
    }

    public void setInviteLink(String inviteLink){
        this.inviteLink = inviteLink;
    }

    public void setInviteQrCode(String inviteQrCode){
        this.inviteQrCode = inviteQrCode;
    }
}