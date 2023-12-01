package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
    private final FcmUtils fcmUtils;

    public void notifyParticipant(User user, Long targetUserId, Long studyId) {
        User targetUser = userRepository.findById(targetUserId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        String body = String.format("[%s]님이 회원님을 콕 찔렀습니다.",  user.getNickname());
        fcmUtils.sendNotificationByTokens(targetUser.getFcmTokenList(), "콕찌르기", body);
    }

    @Transactional
    public void deleteFcmToken(User user, String token) {
        user.deleteFcmToken(token);
    }
}
