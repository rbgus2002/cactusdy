package ssu.groupstudy.domain.study.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@Getter
public class Invite {
    @Column(name = "invite_link", nullable = false)
    private String link;

    @Column(name = "invite_qr_code", nullable = false)
    private String qrCode;

    // TODO : invite 생성 코드 작성
    protected static Invite generate(){
        return new Invite();
    }

    public Invite(){
        this.link = "not yet";
        this.qrCode = "not yet";
    }
}
