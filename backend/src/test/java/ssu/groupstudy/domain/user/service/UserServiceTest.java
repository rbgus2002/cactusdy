package ssu.groupstudy.domain.user.service;

import org.mockito.InjectMocks;
import org.mockito.Mock;
import ssu.groupstudy.domain.common.ServiceTest;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.util.S3Utils;

class UserServiceTest extends ServiceTest {
    @InjectMocks
    private UserService userService;
    @Mock
    private UserRepository userRepository;
    @Mock
    private S3Utils s3Utils;
}