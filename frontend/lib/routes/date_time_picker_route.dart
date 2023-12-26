

import 'package:flutter/material.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';
import 'package:groupstudy/widgets/pickers/custom_calendar_date_picker.dart';

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
  late final DateTime _initDate;
  late DateTime? _date;
  late DateTime _time;

  @override
  void initState() {
    super.initState();

    _date = widget.round.studyTime??DateTime.now();
    _time = widget.round.studyTime??DateTime(0, 0, 0, 12, 0);
    _initDate = _date!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
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
                initialDate: _initDate,
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime(2100, 12, 31),),),

            // Time Picker Button
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: context.extraColors.grey200!),),),
              child: InkWell(
                onTap: (_date != null)?
                    () => BottomSheets.timePickerBottomSheet(
                      context: context,
                      initTime: _time,
                      onSelected: _pickTime,) :
                    null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.local.time,
                          style: TextStyles.head4,),),

                      Text(
                        (_date != null) ?
                          TimeUtility.getTime(_time) :
                          '- -  - - : - -',
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

  void _pickDate(DateTime? date) {
    setState(() => _date = date);
  }

  void _pickTime(DateTime time) {
    setState(() => _time = time);
  }

  void _updateStudyTime() async {
    DateTime? newStudyTime;
    if (_date != null) {
      newStudyTime = DateTime(
          _date!.year,
          _date!.month,
          _date!.day,
          _time.hour,
          _time.minute);
    }

    try {
      widget.round.studyTime = newStudyTime;
      await Round.updateAppointment(widget.round).then((value) {
        Util.popRoute(context);
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
