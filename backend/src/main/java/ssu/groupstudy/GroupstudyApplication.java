package ssu.groupstudy;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
@Slf4j
public class GroupstudyApplication {
    public static void main(String[] args) {
        SpringApplication.run(GroupstudyApplication.class, args);
    }

    // TODO : log4j2 config 설정 및 로그 실무 적용 패턴(파일 저장) 검색
}
