package ssu.groupstudy.domain.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.notification.entity.FcmTokenEntity;
import ssu.groupstudy.domain.notification.repository.FcmTokenEntityRepository;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.util.List;
import java.util.Optional;

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
        Optional<FcmTokenEntity> fcmTokenEntity = fcmTokenEntityRepository.findByTokenAndUser(token, user);

        if(fcmTokenEntity.isPresent()){
            fcmTokenEntityRepository.delete(fcmTokenEntity.get());
        }
    }

    public void deleteAllFcmToken(UserEntity userEntity) {
        List<FcmTokenEntity> fcmTokenEntities = fcmTokenEntityRepository.findByUser(userEntity);
        fcmTokenEntityRepository.deleteAllInBatch(fcmTokenEntities);
    }
}
