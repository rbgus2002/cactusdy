import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_study_app/themes/color_styles.dart';

class Toast {
  static void showToast(String content) {
    Fluttertoast.showToast(
      msg: content,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: ColorStyles.orange,
    );
  }
}