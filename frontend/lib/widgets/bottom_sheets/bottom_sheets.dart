

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/status_tag.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/tags/status_tag_widget.dart';

class BottomSheets {
  BottomSheets._();

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

  static Widget _designBar({Color? color}) {
    return Center(
      child: Container(
        width: 100,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: Design.borderRadiusSmall,),),);
  }

  static void statusTagPickerBottomSheet({
    required BuildContext context,
    required Function(StatusTag) onPicked,
    bool reserved = false,
  }) {
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
            _designBar(color: context.extraColors.grey300,),
            Design.padding32,

            Text(
              context.local.attendanceTag,
              style: TextStyles.head3.copyWith(color: context.extraColors.grey900),),
            Design.padding24,

            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: StatusTag.values.length,
                itemBuilder: (context, index) {
                  return StatusTagWidget(
                    context: context,
                    status: StatusTag.values[index],
                    reserved: reserved,
                    onTap: () { 
                      Util.popRoute(context);
                      onPicked(StatusTag.values[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) => Design.padding16,
              ),
            ),
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
            _designBar(color: context.extraColors.grey300,),
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

  static void timePickerBottomSheet({
    required BuildContext context,
    required Function(Color) onChose}) {
      final List<String> amAndPm = [ context.local.am, context.local.pm ];
      const double height = 200;
      const double itemExtent = 36;

      _basicBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 342,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Design.padding12,

              // Design Bar
              _designBar(color: context.extraColors.grey300,),
              Design.padding20,

              Stack(
                alignment: Alignment.center,
                children: [
                  // Selected Bar
                  Container(
                    width: double.maxFinite,
                    height: itemExtent,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: context.extraColors.grey100,
                      borderRadius: Design.borderRadius,),),

                  // Pickers
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // AM/PM
                      SizedBox(
                        width: 80,
                        height: height,
                        child: CupertinoPicker(
                          itemExtent: itemExtent,
                          selectionOverlay: null,
                          children: amAndPm.map((m) => Text(
                            m, style: TextStyles.head2,)).toList(),
                          onSelectedItemChanged: (c){},),),

                      // Hour
                      SizedBox(
                        width: 60,
                        height: height,
                        child: CupertinoPicker(
                          itemExtent: itemExtent,
                          looping: true,
                          selectionOverlay: null,
                          children: List.generate(12, (index) => Text(
                            (index + 1).toString().padLeft(2, '  '), style: TextStyles.head2,)),
                          onSelectedItemChanged: (c){},),),

                      // Min
                      SizedBox(
                        width: 60,
                        height: height,
                        child: CupertinoPicker(
                          itemExtent: itemExtent,
                          looping: true,
                          selectionOverlay: null,
                          children: List.generate(12, (index) => Text(
                            (index * 5).toString().padLeft(2, '0'), style: TextStyles.head2,)),
                          onSelectedItemChanged: (c){},),),
                    ],),
                ],),
              Design.padding16,

              PrimaryButton(
                text: context.local.confirm,
                onPressed: () => Util.popRoute(context),),
            ],),
      ),
    );
  }
}