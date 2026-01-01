package ssu.groupstudy.global.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.common.enums.ProfileImageType;

import java.io.IOException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class ImageManagerTest extends ServiceTest {
    @InjectMocks
    private ImageManager imageManager;

    @Mock
    private ProfileImageStorage profileImageStorage;

    @Test
    @DisplayName("이미지가 null인 경우 이미지를 업데이트하지 않는다.")
    void updateNullImage() throws IOException {
        // given
        doReturn(null).when(profileImageStorage).saveProfileImage(any(ProfileImageType.class), any(Long.class), any());

        // when
        최규현.updatePicture("image");
        imageManager.updateImage(최규현, null);

        // then
        softly.assertThat(최규현.getPicture()).isEqualTo("image");
        softly.assertThat(최규현.getPicture()).isNotNull();
    }
}
