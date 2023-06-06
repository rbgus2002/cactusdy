import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class Design{
  static const double padding = 15;
  static const double borderRadius = 10;

  static const EdgeInsets edge5 = EdgeInsets.all(5.0);
  static const EdgeInsets edge10 = EdgeInsets.all(10.0);
  static const EdgeInsets edge15 = EdgeInsets.all(15.0);

  static const SizedBox padding5 = SizedBox(width: 5, height: 5,);
  static const SizedBox padding10 = SizedBox(width: 10, height: 10,);
  static const SizedBox padding15 = SizedBox(width: 15, height: 15,);

  static const List<BoxShadow> basicShadows = [ BoxShadow(
      color: ColorStyles.shadow,
      spreadRadius: 2,
      blurRadius: 3,
      offset: Offset(4, 4),
  )];
}