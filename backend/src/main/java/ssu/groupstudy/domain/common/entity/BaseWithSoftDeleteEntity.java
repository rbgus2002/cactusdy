package ssu.groupstudy.domain.common.entity;

import lombok.Getter;

import javax.persistence.Column;
import javax.persistence.MappedSuperclass;

@Getter
@MappedSuperclass
public class BaseWithSoftDeleteEntity extends BaseEntity {
    @Column(nullable = false)
    private char deleteYn = 'N';

    public void delete() {
        this.deleteYn = 'Y';
    }

    public boolean isDeleted(){
        return this.deleteYn == 'Y';
    }
}
