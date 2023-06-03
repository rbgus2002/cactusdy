package ssu.groupstudy.domain.study.domain;

import lombok.Getter;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@Getter
public class InviteCode {
    @Column(name = "invite_link", nullable = false)
    private String url;

    @Column(name = "invite_qr_code", nullable = false)
    private String qrImage;

    // TODO : invite 생성 코드 작성
    protected static InviteCode generate(){
        return new InviteCode();
    }

    public InviteCode(){
        this.url = "not yet";
        this.qrImage = "not yet";
    }
}
