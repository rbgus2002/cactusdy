package ssu.groupstudy.global.util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.enums.ProfileImageType;
import com.github.f4b6a3.ulid.UlidCreator;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;

@Component
@RequiredArgsConstructor
@Slf4j
public class ProfileImageStorage {
    private static final long DEFAULT_MAX_BYTES = 5L * 1024 * 1024;

    @Value("${app.profile-image.upload-root}")
    private String uploadRoot;

    @Value("${app.profile-image.max-bytes:5242880}")
    private long maxBytes;

    public String saveProfileImage(ProfileImageType type, Long id, MultipartFile image) throws IOException {
        if (image == null) {
            return null;
        }
        if (image.isEmpty()) {
            throw new IllegalArgumentException("Profile image is empty.");
        }
        long limit = maxBytes > 0 ? maxBytes : DEFAULT_MAX_BYTES;
        if (image.getSize() > limit) {
            throw new IllegalArgumentException("Profile image exceeds size limit.");
        }

        String extension = resolveExtension(image.getContentType());
        if (extension == null) {
            extension = "jpg";
//            throw new IllegalArgumentException("Unsupported content type.");
        }

        String fileName = UlidCreator.getUlid().toString() + "." + extension;
        String key = String.format(type.getKeyFormat(), id, fileName);
        Path rootPath = Paths.get(uploadRoot).toAbsolutePath().normalize();
        Path targetPath = rootPath.resolve(key).normalize();
        if (!targetPath.startsWith(rootPath)) {
            throw new IllegalArgumentException("Invalid profile image path.");
        }

        Files.createDirectories(targetPath.getParent());
        Path tempFile = Files.createTempFile(targetPath.getParent(), "upload-", ".tmp");
        try (InputStream inputStream = image.getInputStream()) {
            Files.copy(inputStream, tempFile, StandardCopyOption.REPLACE_EXISTING);
        }

        try {
            Files.move(tempFile, targetPath, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING);
        } catch (AtomicMoveNotSupportedException ex) {
            Files.move(tempFile, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }
        return key;
    }

    public void deleteByKey(String key) {
        if (key == null || key.isBlank()) {
            return;
        }
        if (key.startsWith("http://") || key.startsWith("https://")) {
            return;
        }
        Path path = keyToPath(key);
        if (path == null) {
            return;
        }
        try {
            Files.deleteIfExists(path);
        } catch (IOException ex) {
            log.warn("Failed to delete profile image: {}", key, ex);
        }
    }

    public Path keyToPath(String key) {
        if (key == null || key.isBlank()) {
            return null;
        }
        Path rootPath = Paths.get(uploadRoot).toAbsolutePath().normalize();
        Path path = rootPath.resolve(key).normalize();
        if (!path.startsWith(rootPath)) {
            log.warn("Invalid profile image key: {}", key);
            return null;
        }
        return path;
    }

    public String keyToUrl(String key) {
        return ProfileImageUrlResolver.toUrl(key);
    }

    private String resolveExtension(String contentType) {
        if (contentType == null) {
            return null;
        }
        String normalized = contentType.toLowerCase(Locale.ROOT);
        switch (normalized) {
            case "image/jpeg":
            case "image/jpg":
                return "jpg";
            case "image/png":
                return "png";
            case "image/gif":
                return "gif";
            case "image/webp":
                return "webp";
            default:
                return null;
        }
    }
}
