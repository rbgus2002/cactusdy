package ssu.groupstudy.api.round.vo;

import lombok.*;

import javax.validation.constraints.NotBlank;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class DetailReqVo {
    @NotBlank
    String detail;
}
