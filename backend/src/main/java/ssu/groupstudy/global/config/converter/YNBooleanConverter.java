package ssu.groupstudy.global.config.converter;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter
public class YNBooleanConverter implements AttributeConverter<Boolean, Character> {
    @Override
    public Character convertToDatabaseColumn(Boolean attribute) {
        return (attribute) ? 'Y' : 'N';
    }

    @Override
    public Boolean convertToEntityAttribute(Character dbData) {
        return dbData == 'Y';
    }
}
