
import 'package:intl/intl.dart';

class TimeUtility {
  static String timeToString(DateTime dateTime) {
    final nowTime = DateTime.now();
    final difference = nowTime.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "방금";
    }

    else if (difference.inHours < 1) {
      return '${difference.inMinutes}분전';
    }

    else if (difference.inDays < 1) {
      return '${difference.inHours}시간전';
    }

    else if (nowTime.day - dateTime.day < 2) {
      return '어제';
    }

    if (dateTime.year == nowTime.year) {
      return DateFormat('MM.dd').format(dateTime);
    }

    return DateFormat('yyyy.MM.dd').format(dateTime);
  }
}