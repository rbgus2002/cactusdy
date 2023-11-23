
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:group_study_app/themes/old_design.dart';

class ColorPickerDialog {
  static const Radius _radius = Radius.circular(25);


  static Future<dynamic> showColorPickerDialog({
    required BuildContext context,
    required Color color,
    required Function(Color) onColorChange })
  {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_radius),
          ),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: SlidePicker(
              pickerColor: color,
              colorModel: ColorModel.rgb,
              displayThumbColor: true,
              enableAlpha: false,
              indicatorBorderRadius: const BorderRadius.vertical(top: _radius),
              onColorChanged: onColorChange,
            ),
          ),
        );
      },
    );
  }
}