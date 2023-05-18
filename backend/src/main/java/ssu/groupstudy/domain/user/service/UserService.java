package ssu.groupstudy.domain.user.service;

import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;
import ssu.groupstudy.domain.user.dto.response.UserResponse;
import ssu.groupstudy.domain.user.exception.EmailExistsException;
import ssu.groupstudy.domain.user.exception.UserNotFoundException;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.ResultCode;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;

    @Transactional
    public User signUp(SignUpRequest dto){
        if(userRepository.existsByEmail(dto.getEmail())){
            throw new EmailExistsException(ResultCode.DUPLICATE_EMAIL);
        }

        User newUser = userRepository.save(dto.toEntity());
        return newUser;
    }

    public UserResponse getUser(long userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new UserNotFoundException(ResultCode.USER_NOT_FOUND));

        return UserResponse.from(user);
    }
}
