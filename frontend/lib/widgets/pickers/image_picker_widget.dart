

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/diagrams/squircle.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(XFile)? onPicked;
  final ShapeBorder? shape;
  final String url;
  final Color? backgroundColor;

  const ImagePickerWidget({
    super.key,
    required this.onPicked,
    this.backgroundColor,
    this.shape,
    this.url = "",
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  static const double _imageMaxSize = 640;
  static const double _size = 80;
  static const double _overlaySize = 36;
  static const double _iconSize = 24;

  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      clipBehavior: Clip.none,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(_size / 2),
          onTap: () => pickImage(),
          child: SizedBox(
            width: _size,
            height: _size,
            child: ClipPath.shape(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: widget.shape??const SquircleBorder(),
                child: Material(
                  color: widget.backgroundColor??context.extraColors.inputFieldBackgroundColor,
                  shape: widget.shape?? SquircleBorder(
                      side: BorderSide(color: context.extraColors.grey200!, width: 2)),
                  child: _loadImage(),
                )),
          )),

        Positioned(
          left: 58,
          top: 47,
          child: Container(
            width: _overlaySize,
            height: _overlaySize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.extraColors.grey000,
              border: Border.all(color: context.extraColors.grey200!, width: 2),),
            child: Icon(
              CustomIcons.camera,
              color: context.extraColors.grey400,
              size: _iconSize,),),)
      ],
    );
  }

  Widget? _loadImage() {
    if (imageFile != null) {
      return Image.file(
        File(imageFile!.path),
        fit: BoxFit.cover,
      );
    }
    else if (widget.url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.url,
        fit: BoxFit.cover);
    }

    return null;
  }

  void pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? loadedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: _imageMaxSize,
        maxHeight: _imageMaxSize,
    );

    if (loadedImageFile != null) {
      setState(() => imageFile = loadedImageFile);

      if (widget.onPicked != null) {
        widget.onPicked!(imageFile!);
      }
    }
  }
}