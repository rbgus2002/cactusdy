package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.study.domain.Study;
import ssu.groupstudy.domain.study.exception.StudyNotFoundException;
import ssu.groupstudy.domain.study.repository.StudyRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.util.FcmUtils;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NotificationService {
    private final UserRepository userRepository;
    private final StudyRepository studyRepository;
    private final FcmUtils fcmUtils;

    public void notifyParticipant(User me, Long targetUserId, Long studyId) {
        User target = userRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        Study study = studyRepository.findById(studyId)
                .orElseThrow(() -> new StudyNotFoundException(ResultCode.STUDY_NOT_FOUND));

        StringBuilder body = new StringBuilder();
        body.append("'").append(me.getNickname()).append("'").append("님이 회원님을 콕 찔렀어요");
        fcmUtils.sendNotificationByTokens(target.getFcmTokenList(), study.getStudyName(), body.toString());
    }

    @Transactional
    public void deleteFcmToken(User user, String token) {
        user.deleteFcmToken(token);
    }
}
