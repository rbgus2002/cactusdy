

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final double scale;
  final double? borderRadius;
  final Function(XFile)? onPicked;

  const ImagePickerWidget({
    Key? key,
    this.scale = 150.0,
    this.borderRadius,
    required this.onPicked,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(widget.borderRadius??(widget.scale/2));
    return Container(
      width: widget.scale,
      height: widget.scale,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        child: (imageFile == null)?
            Image.asset(Design.defaultImagePath) :
            Image.file(
              File(imageFile!.path),
              fit: BoxFit.cover,
            ),
        onTap: () => pickImage(),
      ),
    );
  }

  void pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? loadedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 640,
        maxHeight: 640,
    );

    if (loadedImageFile != null) {
      imageFile = loadedImageFile;
      setState(() { });

      if (widget.onPicked != null) {
        widget.onPicked!(imageFile!);
      }
    }
  }
}