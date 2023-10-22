package ssu.groupstudy.domain.round.dto.request;

import lombok.*;

import javax.validation.constraints.NotBlank;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class DetailRequest {
    @NotBlank
    String detail;
}
