package ssu.groupstudy.domain.study.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.study.exception.InviteLinkAlreadyExistsException;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.domain.BaseEntity;
import ssu.groupstudy.global.error.ResultCode;

@Entity
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

    @Builder // TODO : User를 어떤식으로 넣어줄건지, 그리고 마저 인자 정해서 생성자 만들어주기
    public Study(Long studyId, String studyName, String detail, String picture, User hostUser) {
        this.studyId = studyId;
        this.studyName = studyName;
        this.detail = detail;
        this.picture = picture;
        this.inviteLink = inviteLink;
        this.inviteQrCode = inviteQrCode;
        this.hostUser = hostUser;
        this.deleteYn = deleteYn;
    }

    public void setInviteLink(String inviteLink){
        if(existInviteLink())
            throw new InviteLinkAlreadyExistsException(ResultCode.DUPLICATE_INVITE_LINK_ERROR);
        this.inviteLink = inviteLink;
    }

    private boolean existInviteLink(){
        return inviteLink != null;
    }
}