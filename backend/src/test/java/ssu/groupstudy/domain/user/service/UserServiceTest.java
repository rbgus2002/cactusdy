package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;
import java.net.URL;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private S3Utils s3Utils;

    @Test
    @DisplayName("프로필 상태메세지를 업데이트한다")
    void updateStatusMessage(){
        // given
        String newMessage = "updated";
        StatusMessageRequest statusMessageRequest = new StatusMessageRequest(newMessage);

        // when
        userService.updateStatusMessage(최규현, statusMessageRequest);

        // then
        softly.assertThat(최규현.getStatusMessage()).isEqualTo(newMessage);
    }

    @Test
    @DisplayName("프로필 이미지를 업데이트한다")
    void updateProfileImage() throws IOException {
        // given
        URL newPicture = new URL("https://groupstudy-image.s3.ap-northeast-2.amazonaws.com/groupstudy-user-profile-1");
        doReturn(newPicture.toString()).when(s3Utils).uploadProfileImage(any(), any(), any(Long.class));

        // when
        MultipartFile mock = new MockMultipartFile("tmp", new byte[1]);
        userService.updateProfileImage(최규현, mock);

        // then
        softly.assertThat(최규현.getPicture()).isEqualTo(newPicture.toString());
    }
}