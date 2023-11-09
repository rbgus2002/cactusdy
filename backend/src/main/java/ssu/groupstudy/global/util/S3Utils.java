package ssu.groupstudy.global.util;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.constant.S3Code;

import java.io.IOException;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class S3Utils {
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String imageBucket;

    public String uploadUserProfileImage(MultipartFile image, User user) throws IOException {
        log.info("## uploadUserProfileImage ");
        ObjectMetadata metadata = createMetadataForFile(image);
        String imageName = generateImageName(S3Code.USER_IMAGE, user);
        amazonS3.putObject(imageBucket, imageName, image.getInputStream(), metadata);
        return amazonS3.getUrl(imageBucket, imageName).toString();
    }

    private ObjectMetadata createMetadataForFile(MultipartFile file) {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());
        return metadata;
    }

    private String generateImageName(S3Code code, User user) {
        return String.format(code.getFormat(), user.getUserId(), UUID.randomUUID());
    }
}
