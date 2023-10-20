package ssu.groupstudy.domain.user.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;

    @Mock
    private UserRepository userRepository;

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

//    @Test
//    @DisplayName("프로필 이미지를 업데이트한다")
//    void updateProfileImage(){
//        // given
//        String newPicture = "updated";
//
//        // when
//        userService.updateProfileImage(최규현, null);
//
//        // then
//        softly.assertThat(최규현.getPicture()).isEqualTo(newPicture);
//    }
}