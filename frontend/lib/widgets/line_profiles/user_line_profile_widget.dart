import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/line_profiles/line_profile_widget.dart';

class UserLineProfileWidget extends StatefulWidget {
  final User user;

  const UserLineProfileWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserLineProfileWidget> createState() => _UserLineProfileWidgetState();
}

class _UserLineProfileWidgetState extends State<UserLineProfileWidget> {
  static const String _statusMessageHintText = "상태 메세지를 입력해 주세요";
  static const double _scale = 50;

  late final TextEditingController _statusMessageEditingController;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _statusMessageEditingController =
        TextEditingController(text: widget.user.statusMessage);
  }

  @override
  Widget build(BuildContext context) {
    return LineProfileWidget(
      circleButton: CircleButton(
        scale: _scale,
        url: widget.user.picture,
        onTap: () => Test.onTabTest(),
      ),

      topWidget: Text(widget.user.nickname, maxLines: 1, style: OldTextStyles.titleMedium,),
      bottomWidget: TextField(
        maxLength: User.statusMessageMaxLength,
        maxLines: 1,
        style: OldTextStyles.bodyMedium,

        controller: _statusMessageEditingController,
        decoration: const InputDecoration(
          hintText: _statusMessageHintText,
          hintStyle: OldTextStyles.roundHintTextStyle,
          isDense: true,
          contentPadding: EdgeInsets.zero,

          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: OldColorStyles.taskTextColor)),
          counterText: "",
        ),

        onChanged: (value) => _isEdited = true,
        onTapOutside: (event) => updateStatusMessage(),
        onSubmitted: (value) => updateStatusMessage(),
      ),

      suffixWidget: (widget.user.userId != Auth.signInfo!.userId)? null : IconButton(
        icon: OldAppIcons.edit,
        splashRadius: 16,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 18,
        onPressed: (){},
      ),
    );
  }

  void updateStatusMessage() {
    if (_isEdited) {
      widget.user.statusMessage = _statusMessageEditingController.text;
      User.updateStatusMessage(widget.user);
      _isEdited = false;
    }
    setState(() {});
  }
}