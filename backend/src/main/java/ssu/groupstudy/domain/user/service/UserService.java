package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.api.user.vo.UserInfoResVo;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.api.user.vo.EditUserReqVo;
import ssu.groupstudy.domain.common.enums.S3Code;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final S3Utils s3Utils;

    @Transactional
    public UserInfoResVo editUser(EditUserReqVo dto, MultipartFile profileImage, UserEntity user) throws IOException {
        user.editProfile(dto.getNickname(), dto.getStatusMessage());
        handleUploadProfileImage(user, profileImage);
        return UserInfoResVo.from(user);
    }

    private void handleUploadProfileImage(UserEntity user, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.USER_IMAGE, user.getUserId());
        user.updatePicture(imageUrl);

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
