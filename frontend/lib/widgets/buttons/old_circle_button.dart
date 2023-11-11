import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_design.dart';

class OldCircleButton extends StatelessWidget {
  final double scale;
  final double? borderRadius;
  final String url;
  final Function? onTap;

  const OldCircleButton({
    Key? key,
    required this.url,
    this.scale = 20.0,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(this.borderRadius??(scale / 2));
    return Container(
      width: scale,
      height: scale,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: borderRadius,),
      child: InkWell(
        borderRadius: borderRadius,
        child: (url.isNotEmpty)?
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover) :
          Image.asset(
            OldDesign.defaultImagePath,
            fit: BoxFit.cover),
        onTap: () {
          if (onTap != null) onTap!();
        },
      ),
    );
  }
}