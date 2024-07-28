package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.entity.FcmTokenEntity;
import ssu.groupstudy.domain.notification.repository.FcmTokenEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class FcmTokenService {
    private final FcmTokenEntityRepository fcmTokenEntityRepository;

    @Transactional
    public void saveFcmToken(String fcmToken, UserEntity user) {
        FcmTokenEntity fcmTokenEntity = fcmTokenEntityRepository.findByTokenAndUser(fcmToken, user)
                .orElseGet(() -> FcmTokenEntity.from(user, fcmToken));
        fcmTokenEntity.updateActivateDate();
        fcmTokenEntityRepository.save(fcmTokenEntity);
    }

    @Transactional
    public void deleteFcmToken(UserEntity user, String token) {
        FcmTokenEntity fcmTokenEntity = fcmTokenEntityRepository.findByTokenAndUser(token, user)
                .orElseThrow(() -> new IllegalArgumentException("해당 토큰이 존재하지 않습니다."));
        fcmTokenEntityRepository.delete(fcmTokenEntity);
    }

    @Transactional
    public void deleteAllFcmToken(UserEntity userEntity) {
        List<FcmTokenEntity> fcmTokenEntities = fcmTokenEntityRepository.findByUser(userEntity);
        fcmTokenEntityRepository.deleteAllInBatch(fcmTokenEntities);
    }
}
