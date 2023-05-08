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
    // TODO : API 호출 시 경과시간을 log에 같이 담아서 api 경로 출력하도록 구현 (AOP Annotation 적용)
    // TODO : Transaction 공부 후 일괄 적용
}
