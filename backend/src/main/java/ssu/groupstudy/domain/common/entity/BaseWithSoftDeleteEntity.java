package ssu.groupstudy.domain.common.entity;

import lombok.Getter;
import ssu.groupstudy.global.config.converter.YNBooleanConverter;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.MappedSuperclass;

@Getter
@MappedSuperclass
public class BaseWithSoftDeleteEntity extends BaseEntity {
    @Column(nullable = false)
    @Convert(converter = YNBooleanConverter.class)
    private boolean deleteYn = false;

    public void delete() {
        this.deleteYn = true;
    }

    public boolean isDeleted(){
        return this.deleteYn;
    }
}
