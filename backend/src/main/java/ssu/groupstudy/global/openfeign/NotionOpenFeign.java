package ssu.groupstudy.global.openfeign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "NotionOpenFeign", url = "https://api.notion.com/v1")
public interface NotionOpenFeign {
    // TODO : Notion 전용 Config 생성 후 header, consumes 설정
    @PostMapping(value = "/pages", consumes = "application/json", headers = {"Authorization=Bearer ${notion.api.private-key}", "Notion-Version=${notion.api.version}"})
    void createPage(@RequestBody String body);
}
