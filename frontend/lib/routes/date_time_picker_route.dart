

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:group_study_app/widgets/custom_calendar_date_picker.dart';

class DateTimePickerRoute extends StatelessWidget {
  DateTime dateTime = DateTime.now();

  DateTimePickerRoute({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Close button
        leading: IconButton(
            icon: const Icon(CustomIcons.close),
            iconSize: 32,
            onPressed: () => Util.popRoute(context)),
        shape: InputBorder.none,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date Picker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomCalendarDatePicker(
                onDateChanged: (value) {},
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ),),

            // Time Picker Button
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: context.extraColors.grey200!)),),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.local.time,
                          style: TextStyles.head4,),),

                      Text(
                        TimeUtility.getTime(DateTime.now()),
                        style: TextStyles.head4.copyWith(color: ColorStyles.mainColor),),
                      Design.padding8,

                      Icon(
                        CustomIcons.chevron_down,
                        size: 32,
                        color: context.extraColors.grey500,),
                    ],),
                ),
                onTap: () => BottomSheets.timePickerBottomSheet(
                    context: context, onChose: (p0) {},),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
