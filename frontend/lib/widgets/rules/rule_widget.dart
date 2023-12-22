
import 'package:flutter/material.dart';
import 'package:groupstudy/models/rule.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class RuleWidget extends StatefulWidget {
  final Rule rule;
  final bool enable;
  final Function(Rule) onUpdateRuleDetail;
  final Function(Rule) onDeleteRule;
  final double height;

  const RuleWidget({
    Key? key,
    required this.rule,
    required this.onUpdateRuleDetail,
    required this.onDeleteRule,
    required this.enable,
    this.height = 40,
  }) : super(key: key);

  @override
  State<RuleWidget> createState() => _RuleWidgetState();
}

class _RuleWidgetState extends State<RuleWidget> {
  final _textEditor = TextEditingController();
  final _focusNode = FocusNode();

  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    _textEditor.text = widget.rule.detail;

    return SizedBox(
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CustomIcons.check1,
            size: 16,
            color: context.extraColors.grey500),
          Design.padding8,

          Flexible(
            fit: FlexFit.tight,
            child: TextField(
              autofocus: _isAdded(),
              focusNode: _focusNode,
              enabled: widget.enable,
              maxLines: 1,
              maxLength: Rule.ruleMaxLength,
              style: TextStyles.body1.copyWith(
                color: context.extraColors.grey600,),

              controller: _textEditor,
              decoration: InputDecoration(
                isDense: true,
                hintText: context.local.inputHint1(context.local.rules),
                hintStyle: TextStyles.body1.copyWith(
                  color: context.extraColors.grey400,),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                counterText: "",
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: context.extraColors.grey700!,),),),

              onChanged: (value) => _isEdited = true,
              onTapOutside: (event) => _updateRule(),
              onSubmitted: (value) => _updateRule(),
            ),),
      ],),
    );
  }

  @override
  void dispose() {
    _textEditor.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateRule() {
    if (_isEdited || _textEditor.text.isEmpty) {
      widget.rule.detail = _textEditor.text;

      if (widget.rule.detail.isNotEmpty) {
        widget.onUpdateRuleDetail(widget.rule);
      } else {
        widget.onDeleteRule(widget.rule);
      }

      _isEdited = false;
    }

    _focusNode.unfocus();
    setState(() {});
  }

  bool _isAdded() {
    return widget.rule.ruleId == Rule.nonAllocatedRuleId;
  }
}
