import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/utilities/extensions.dart';

class CircleButton extends StatelessWidget {
  final double size;
  final String url;
  final Function? onTap;

  const CircleButton({
    Key? key,
    required this.url,
    this.size = 20.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: context.extraColors.grey000,
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(1.5),
        child: ClipOval(
          child: (url.isNotEmpty)?
            CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover) :
            Image.asset(
                OldDesign.defaultImagePath,
                fit: BoxFit.cover),),),
    );
  }
}