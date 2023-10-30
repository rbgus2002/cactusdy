import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_study_app/themes/old_color_styles.dart';


class Toast {
  static void showToast( { required String msg, ToastGravity? position}) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: position??ToastGravity.BOTTOM,
      backgroundColor: OldColorStyles.orange,
    );
  }
}