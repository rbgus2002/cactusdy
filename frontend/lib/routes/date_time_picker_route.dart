

import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
import 'package:group_study_app/widgets/custom_calendar_date_picker.dart';

class DateTimePickerRoute extends StatefulWidget {
  final Round round;

  const DateTimePickerRoute({
    Key? key,
    required this.round,
  }) : super(key: key);

  @override
  State<DateTimePickerRoute> createState() => _DateTimePickerRouteState();
}


class _DateTimePickerRouteState extends State<DateTimePickerRoute> {
  late DateTime _date;
  late DateTime _time;

  @override
  void initState() {
    super.initState();

    _date = widget.round.studyTime??DateTime.now();
    _time = widget.round.studyTime??DateTime.now();
  }

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
      bottomNavigationBar: _doneModifyButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date Picker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomCalendarDatePicker(
                onDateChanged: _pickDate,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),),),

            // Time Picker Button
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: context.extraColors.grey200!),),),
              child: InkWell(
                onTap: () => BottomSheets.timePickerBottomSheet(
                  context: context,
                  initTime: _time,
                  onSelected: _pickTime,),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.local.time,
                          style: TextStyles.head4,),),

                      Text(
                        TimeUtility.getTime(_time),
                        style: TextStyles.head4.copyWith(color: ColorStyles.mainColor),),
                      Design.padding8,

                      SizedBox(
                        width: 28,
                        child: Icon(
                          CustomIcons.chevron_down,
                          size: 32,
                          color: context.extraColors.grey500,),
                      ),
                    ],),
                ),),
            ),
          ],),
      ),
    );
  }

  Widget _doneModifyButton() {
    return Container(
      color: context.extraColors.grey000,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 44),
      child: PrimaryButton(
        text: context.local.doneModify,
        onPressed: _updateStudyTime,),
    );
  }

  void _pickDate(DateTime date) {
    setState(() => _date = date);
  }

  void _pickTime(DateTime time) {
    setState(() => _time = time);
  }

  void _updateStudyTime() async {
    DateTime newStudyTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

    try {
      widget.round.studyTime = newStudyTime;
      await Round.updateAppointment(widget.round).then((value) {
        Util.popRoute(context);
        Toast.showToast(
            context: context,
            message: context.local.successToDo(context.local.editing));
      });
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }
}
