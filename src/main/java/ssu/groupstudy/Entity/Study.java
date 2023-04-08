package ssu.groupstudy.Entity;

import jakarta.persistence.*;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
public class Study {
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

    //TODO JPAudit 연동
}