package ssu.groupstudy.domain.feedback.dto;

import lombok.Getter;
import lombok.ToString;
import ssu.groupstudy.domain.feedback.domain.FeedbackType;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Getter
@ToString
public class CreateNotionPageDto {
    private Map<String, String> parent;
    private Map<String, Object> properties;
    private List<Map<String, Object>> children;

    public static CreateNotionPageDto create(String title, String contents, Long userId, FeedbackType type) {
        return new CreateNotionPageDto(title, contents, userId, type);
    }

    private CreateNotionPageDto(String title, String contents, Long userId, FeedbackType type) {
        this.parent = Map.of("type", "database_id",
                "database_id", "274c1b32db734837b9c21281f080f517");
        this.properties = createPropertiesMap(title, userId, type);
        this.children = createChildrenList(contents);
    }

    private Map<String, Object> createPropertiesMap(String title, Long userId, FeedbackType type) {
        Map<String, Object> map = new HashMap<>();
        map.put("Name", createNameMap(title));
        map.put("Type", createTypeMap(type));
        map.put("user_id", createUserIdMap(userId));
        return map;
    }

    private Map<String, Object> createNameMap(String title) {
        Map<String, Object> map = new HashMap<>();
        map.put("title", Arrays.asList(
                Map.of("text", Map.of("content", title))
        ));
        return map;
    }

    private Map<String, Object> createTypeMap(FeedbackType type) {
        Map<String, Object> map = new HashMap<>();
        map.put("select", Map.of("name", type.name()));
        return map;
    }

    private Map<String, Object> createUserIdMap(Long userId) {
        Map<String, Object> map = new HashMap<>();
        map.put("rich_text", List.of(
                Map.of("text", Map.of("content", userId.toString()))
        ));
        return map;
    }

    private List<Map<String, Object>> createChildrenList(String contents) {
        Map<String, Object> textContent = Map.of("text", Map.of("content", contents));
        Map<String, Object> paragraph = Map.of("rich_text", List.of(textContent));
        Map<String, Object> child = Map.of("object", "block",
                "paragraph", paragraph);
        return List.of(child);
    }
}
