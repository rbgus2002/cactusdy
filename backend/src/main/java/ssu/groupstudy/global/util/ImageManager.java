package ssu.groupstudy.global.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;
import ssu.groupstudy.domain.common.enums.S3Code;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class ImageManager {
    private final S3Utils s3Utils;

    // TODO : 디자인패턴 생각해보기
    public void updateImage(UserEntity user, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.USER_IMAGE, user.getUserId());
        user.updatePicture(imageUrl);
    }

    public void updateImage(StudyEntity study, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String imageUrl = s3Utils.uploadProfileImage(image, S3Code.STUDY_IMAGE, study.getStudyId());
        study.updatePicture(imageUrl);
    }
}
