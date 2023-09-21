package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.login.security.jwt.JwtProvider;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.UserInfoResponse;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;

    @Transactional
    public Long signUp(SignUpRequest request){
        if(userRepository.existsByEmail(request.getEmail())){
            throw new EmailExistsException(ResultCode.DUPLICATE_EMAIL);
        }
        User user = request.toEntity(passwordEncoder);
        user.setAuthority("ROLE_USER");
        
        return userRepository.save(user).getUserId();
    }

    public UserInfoResponse getUser(long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        return UserInfoResponse.from(user);
    }
}
