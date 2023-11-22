

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/tags/rounded_tag.dart';

class BottomSheets {
  static void _basicBottomSheet({
    required BuildContext context,
    required WidgetBuilder builder}) {
    showModalBottomSheet(
        barrierColor: context.extraColors.barrierColor!,
        backgroundColor: context.extraColors.grey000,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),),),
        context: context,
        builder: builder);
  }

  static void statusTagPickerBottomSheet({
    required BuildContext context,
    required VoidCallback onChose}) {
    _basicBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 256,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding12,

            // Design Bar
            Center(
              child: Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: context.extraColors.grey300,
                  borderRadius: Design.borderRadiusSmall,),),),
            Design.padding32,

            Text(
              context.local.attendanceTag,
              style: TextStyles.head3.copyWith(color: context.extraColors.grey900),),
            Design.padding24,

            Row(
              children: [
                RoundedTag(
                  width: 60,
                  height: 36,
                  color: context.extraColors.pink!,
                  text: Text(
                    context.local.attend,
                    style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                  onTap: () {},),
                Design.padding16,

                RoundedTag(
                  width: 60,
                  height: 36,
                  color: context.extraColors.green!,
                  text: Text(
                    context.local.late,
                    style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                  onTap: () {},),
                Design.padding16,

                RoundedTag(
                  width: 60,
                  height: 36,
                  color: context.extraColors.mint!,
                  text: Text(
                    context.local.absent,
                    style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
                  onTap: () {},),
              ],),
            Design.padding24,

            OutlinedPrimaryButton(
              text: context.local.confirm,
              onPressed: () => Util.popRoute(context),),
          ],),
      ),
    );
  }



  static void colorPickerBottomSheet({
    required BuildContext context,
    required Function(Color) onChose}) {
    _basicBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 434,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding12,

            // Design Bar
            Center(
              child: Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: context.extraColors.grey300,
                  borderRadius: Design.borderRadiusSmall,),),),
            Design.padding28,

            Text(
              context.local.studyColor,
              style: TextStyles.head3.copyWith(color: context.extraColors.grey900),),
            Design.padding32,

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1,
                crossAxisSpacing: 32,
                mainAxisSpacing: 24,),
              itemCount: ColorStyles.studyColors.length,
              itemBuilder: (context, index) =>
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: ColorStyles.studyColors[index],),
                  onTap: () {
                    onChose(ColorStyles.studyColors[index]);
                    Util.popRoute(context);},
                ),),
            Design.padding4,

            OutlinedPrimaryButton(
              text: context.local.confirm,
              onPressed: () => Util.popRoute(context),),
          ],),
      ),
    );
  }
}