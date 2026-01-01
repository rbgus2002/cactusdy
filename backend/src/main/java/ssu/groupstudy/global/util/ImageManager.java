package ssu.groupstudy.global.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.enums.ProfileImageType;
import ssu.groupstudy.domain.study.entity.StudyEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class ImageManager {
    private final ProfileImageStorage profileImageStorage;

    public void updateImage(UserEntity user, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String oldKey = user.getPictureKey();
        String newKey = profileImageStorage.saveProfileImage(ProfileImageType.USER_IMAGE, user.getUserId(), image);
        if (newKey != null) {
            user.updatePicture(newKey);
            profileImageStorage.deleteByKey(oldKey);
        }
    }

    public void updateImage(StudyEntity study, MultipartFile image) throws IOException {
        if (image == null) {
            return;
        }
        String oldKey = study.getPictureKey();
        String newKey = profileImageStorage.saveProfileImage(ProfileImageType.STUDY_IMAGE, study.getStudyId(), image);
        if (newKey != null) {
            study.updatePicture(newKey);
            profileImageStorage.deleteByKey(oldKey);
        }
    }
}
