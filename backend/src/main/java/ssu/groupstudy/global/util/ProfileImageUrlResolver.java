package ssu.groupstudy.global.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Component
public class ProfileImageUrlResolver {
    private static String baseUrl;

    @Value("${app.profile-image.base-url}")
    private String configuredBaseUrl;

    @PostConstruct
    void init() {
        baseUrl = normalizeBaseUrl(configuredBaseUrl);
    }

    public static String toUrl(String key) {
        if (key == null || key.isBlank()) {
            return null;
        }
        if (key.startsWith("http://") || key.startsWith("https://")) {
            return key;
        }
        if (baseUrl == null) {
            return key;
        }
        return baseUrl + key;
    }

    private static String normalizeBaseUrl(String url) {
        if (url == null || url.isBlank()) {
            return null;
        }
        return url.endsWith("/") ? url : url + "/";
    }
}
