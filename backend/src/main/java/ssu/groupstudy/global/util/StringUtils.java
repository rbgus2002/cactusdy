package ssu.groupstudy.global.util;

public class StringUtils {
    public static String buildMessage(String... word) {
        StringBuilder message = new StringBuilder();
        for (String s : word) {
            message.append(s);
        }
        return message.toString();
    }
}
