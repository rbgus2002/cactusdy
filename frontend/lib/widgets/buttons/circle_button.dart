import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';

class CircleButton extends StatelessWidget {
  final double size;
  final double borderWidth;
  final String url;
  final Function? onTap;

  const CircleButton({
    super.key,
    required this.url,
    this.size = 20.0,
    this.borderWidth = 1.5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: context.extraColors.grey000,
      child: Container(
        height: size - borderWidth * 2,
        width: size - borderWidth * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.extraColors.grey200,),
        child: ClipOval(
          child:(url.isNotEmpty)?
            CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover) :
            Image.asset(
                Design.defaultProfileImagePath,
                color: context.extraColors.grey300,
                fit: BoxFit.cover),),),
    );
  }
}