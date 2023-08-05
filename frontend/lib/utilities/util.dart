import 'package:flutter/material.dart';

class Util {
  static void pushRoute(BuildContext context, WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
  }
}