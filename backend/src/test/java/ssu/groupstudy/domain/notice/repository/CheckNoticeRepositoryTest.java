package ssu.groupstudy.domain.notice.repository;

import org.assertj.core.api.SoftAssertions;
import org.assertj.core.api.junit.jupiter.InjectSoftAssertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import ssu.groupstudy.domain.common.CustomRepositoryTest;
import ssu.groupstudy.domain.notice.domain.CheckNotice;
import ssu.groupstudy.domain.user.domain.UserEntity;

@CustomRepositoryTest
class CheckNoticeRepositoryTest {
    @InjectSoftAssertions
    private SoftAssertions softly;
    @Autowired
    private CheckNoticeRepository checkNoticeRepository;

    @Test
    @DisplayName("지연 로딩 테스트")
    void equalsAndHashTest(){
        // given
        CheckNotice 최규현꺼 = checkNoticeRepository.findById(1L).get();

        // when
        UserEntity 최규현Proxy = 최규현꺼.getUser();
        UserEntity 최규현Proxy_2 = 최규현꺼.getUser();

        // then
        softly.assertThat(최규현Proxy).isEqualTo(최규현Proxy_2);
    }
}