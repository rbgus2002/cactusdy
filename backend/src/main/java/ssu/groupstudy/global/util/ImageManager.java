package ssu.groupstudy.global.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.S3TypeCode;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class ImageManager {
    private final S3Utils s3Utils;

    public void updateImage(UserEntity user, MultipartFile image) throws IOException {
        String imageUrl = s3Utils.uploadProfileImage(image, S3TypeCode.USER_IMAGE, user.getUserId());
        if (imageUrl != null) {
            user.updatePicture(imageUrl);
        }
    }

    public void updateImage(StudyEntity study, MultipartFile image) throws IOException {
        String imageUrl = s3Utils.uploadProfileImage(image, S3TypeCode.STUDY_IMAGE, study.getStudyId());
        if (imageUrl != null) {
            study.updatePicture(imageUrl);
        }
    }
}
