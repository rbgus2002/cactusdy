package ssu.groupstudy.domain.user.service;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

    @Transactional
    public Long signUp(SignUpRequest dto){
        if(userRepository.existsByEmail(dto.getEmail())){
            throw new EmailExistsException(ResultCode.DUPLICATE_EMAIL);
        }
        return userRepository.save(dto.toEntity()).getUserId();
    }

    public UserInfoResponse getUserByUserId(long userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        return UserInfoResponse.from(user);
    }
}
