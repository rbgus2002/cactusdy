package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.EditUserRequest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.global.constant.S3Code;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final S3Utils s3Utils;

    @Transactional
    public UserInfoResponse editUser(EditUserRequest dto, MultipartFile profileImage, User user) throws IOException {
        user.edit(dto.getNickname(), dto.getStatusMessage());
        handleUploadProfileImage(user, profileImage);
        return UserInfoResponse.from(user);
    }

    private void handleUploadProfileImage(User user, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.USER_IMAGE, user.getUserId());
        user.updatePicture(imageUrl);
    }
}
