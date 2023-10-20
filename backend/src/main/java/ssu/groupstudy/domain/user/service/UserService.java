package ssu.groupstudy.domain.user.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.constant.S3Code;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    @Transactional
    public void updateStatusMessage(User user, StatusMessageRequest request) {
        user.setStatusMessage(request.getStatusMessage());
        userRepository.save(user);
    }

    @Transactional
    public String updateProfileImage(User user, MultipartFile requestFile) throws IOException {
        String imageUrl = uploadFileToS3(requestFile, createFileName(user));
        user.setPicture(imageUrl);
        userRepository.save(user);
        return imageUrl;
    }

    private String uploadFileToS3(MultipartFile file, String fileName) throws IOException {
        ObjectMetadata metadata = createMetadataForFile(file);
        amazonS3.putObject(bucket, fileName, file.getInputStream(), metadata);

        return amazonS3.getUrl(bucket, fileName).toString();
    }

    private String createFileName(User user) {
        return S3Code.USER_IMAGE.getPrefix() + user.getUserId();
    }

    private ObjectMetadata createMetadataForFile(MultipartFile file) {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());
        return metadata;
    }
}
