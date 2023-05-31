package ssu.groupstudy.domain.common;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.SignUpRequest;

@ExtendWith(MockitoExtension.class)
public class ServiceTest {
    protected SignUpRequest 최규현SignUpRequest;
    protected SignUpRequest 장재우SignUpRequest;
    protected User 최규현;
    protected User 장재우;

    @BeforeEach
    void setUpSignUpRequest(){
        최규현SignUpRequest = SignUpRequest.builder()
                .name("최규현")
                .email("rbgus200@naver.com")
                .nickName("규규")
                .phoneModel("")
                .picture("")
                .build();
        장재우SignUpRequest = SignUpRequest.builder()
                .name("장재우")
                .email("arkady@naver.com")
                .nickName("킹적화")
                .phoneModel("")
                .picture("")
                .build();
    }

    @BeforeEach
    void setUpUser(){
        최규현 = 최규현SignUpRequest.toEntity();
        ReflectionTestUtils.setField(최규현, "userId", 1L);
        장재우 = 장재우SignUpRequest.toEntity();
        ReflectionTestUtils.setField(장재우, "userId", 2L);
    }
}
