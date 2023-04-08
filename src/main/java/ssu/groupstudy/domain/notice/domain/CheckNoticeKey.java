package ssu.groupstudy.domain.notice.domain;

import lombok.AccessLevel;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CheckNoticeKey implements Serializable {
    private Long notice;
    private Long user;
}
