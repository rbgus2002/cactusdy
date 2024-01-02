

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupstudy/models/status_tag.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/outlined_primary_button.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/tags/status_tag_widget.dart';

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
    required Function(Color) onSelected}) {
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
                    onSelected(ColorStyles.studyColors[index]);
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
    required final DateTime initTime,
    required final Function(DateTime) onSelected}) {
      final List<String> amAndPm = [ context.local.am, context.local.pm ];

      const double height = 200;
      const double itemExtent = 36;

      int aIdx = initTime.hour ~/ 12;
      int hIdx = initTime.hour % 12;
      int mIdx = initTime.minute;

      final amAndPmController = FixedExtentScrollController(initialItem: aIdx);
      final hourController = FixedExtentScrollController(initialItem: hIdx);
      final minController = FixedExtentScrollController(initialItem: mIdx);

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
                    margin: const EdgeInsets.only(bottom: 0),
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
                          scrollController: amAndPmController,
                          itemExtent: itemExtent,
                          selectionOverlay: null,
                          children: amAndPm.map((m) =>
                            Center(
                              child: Text(m, style: TextStyles.head3,),
                            )).toList(),
                          onSelectedItemChanged: (idx) => aIdx = idx),),

                      // Hour
                      SizedBox(
                        width: 60,
                        height: height,
                        child: CupertinoPicker(
                          scrollController: hourController,
                          itemExtent: itemExtent,
                          looping: true,
                          selectionOverlay: null,
                          children: List.generate(12, (index) =>
                            Center(
                              child: Text(
                                ((index == 0)? 12 : index).toString().padLeft(2, '  '),
                                style: TextStyles.head2,),
                            ),),
                          onSelectedItemChanged: (idx) => hIdx = idx,),),

                      // Min
                      SizedBox(
                        width: 60,
                        height: height,
                        child: CupertinoPicker(
                          scrollController: minController,
                          itemExtent: itemExtent,
                          looping: true,
                          selectionOverlay: null,
                          children: List.generate(12, (index) =>
                            Center(
                              child: Text(
                                (index * 5).toString().padLeft(2, '0'), style: TextStyles.head2,),
                            ),),
                          onSelectedItemChanged: (idx) => mIdx = idx),),
                    ],),
                ],),
              Design.padding16,

              PrimaryButton(
                text: context.local.confirm,
                onPressed: () {
                  hIdx %= 12;
                  mIdx %= 12;

                  DateTime pickedTime = TimeUtility.buildDateTime(
                      aIdx: aIdx, hIdx: hIdx, mIdx: mIdx);
                  onSelected(pickedTime);

                  Util.popRoute(context);
                }),
            ],),
      ),
    );
  }
}