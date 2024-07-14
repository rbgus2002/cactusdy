package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.enums.ResultCode;
import ssu.groupstudy.domain.common.enums.S3Code;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.param.UserParam;
import ssu.groupstudy.domain.user.repository.UserEntityRepository;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final S3Utils s3Utils;
    private final UserEntityRepository userEntityRepository;

    @Transactional
    public UserParam editUser(Long userId, String nickname, String statusMessage, MultipartFile image) throws IOException {
        UserEntity userEntity = userEntityRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.USER_IMAGE, userId);
        userEntity.updateProfile(nickname, statusMessage, imageUrl);
        userEntityRepository.save(userEntity);

        return UserParam.from(userEntity);
    }

    @Transactional
    public Long removeUser(UserEntity user) {
        user.deleteUser();
        return user.getUserId();
    }

    @Transactional
    public void updateActivateDate(UserEntity user) {
        user.updateActivateDate();
    }
}
