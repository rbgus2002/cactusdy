package ssu.groupstudy.domain.study.dto;

import lombok.Getter;

@Getter
public class DoneCount {
    private final Long doneCount;
    private final Long undoneCount;
    private final Long sumCount;

    public DoneCount(Long doneCount, Long undoneCount, Long sumCount) {
        this.doneCount = doneCount;
        this.undoneCount = undoneCount;
        this.sumCount = sumCount;
    }

    public int getDoneRate() {
        if (sumCount <= 0) {
            return 0;
        }
        return (int) ((double) doneCount / sumCount * 100);
    }

    public int getUndoneRate() {
        if (sumCount <= 0) {
            return 0;
        }
        return 100 - getDoneRate();
    }
}
