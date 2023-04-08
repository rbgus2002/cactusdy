package ssu.groupstudy.Entity.Key;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
public class CheckNoticeKey implements Serializable {
    private Long notice;
    private Long user;
}
