package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.notification.service.FcmTokenService;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.param.UserParam;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.util.ImageManager;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final ImageManager imageManager;
    private final FcmTokenService fcmTokenService;
    private final UserEntityRepository userEntityRepository;



    @Transactional
    public UserParam editUser(Long userId, String nickname, String statusMessage, MultipartFile image) throws IOException {
        UserEntity userEntity = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        imageManager.updateImage(userEntity, image);
        userEntity.updateProfile(nickname, statusMessage);
        userEntityRepository.save(userEntity);

        return UserParam.from(userEntity);
    }

    @Transactional
    public void removeUser(Long userId) {
        UserEntity userEntity = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        fcmTokenService.deleteAllFcmToken(userEntity);
        userEntity.delete();

    }

    @Transactional
    public void updateActivateDate(Long userId) {
        UserEntity userEntity = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));
        userEntity.updateActivateDate();
    }
}
