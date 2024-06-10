package ssu.groupstudy.domain.feedback.domain;

import lombok.*;
import ssu.groupstudy.domain.user.domain.UserEntity;

import javax.persistence.*;

import static javax.persistence.FetchType.LAZY;

@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Table(name = "feedback")
@ToString
public class Feedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feedback_id")
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private FeedbackType feedbackType;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String contents;

    @ManyToOne(fetch = LAZY)
    @JoinColumn(name = "userId", nullable = false)
    private UserEntity writer;

    private Feedback(FeedbackType feedbackType, String title, String contents, UserEntity writer) {
        this.feedbackType = feedbackType;
        this.title = title;
        this.contents = contents;
        this.writer = writer;
    }

    public static Feedback create(FeedbackType feedbackType, String title, String contents, UserEntity writer) {
        return new Feedback(feedbackType, title, contents, writer);
    }
}
