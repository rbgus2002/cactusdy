
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
              onTapOutside: (event) {
                // empty && tap outside => delete rule
                if (_textEditor.text.isEmpty) {
                  _deleteRule();
                  setState(() { });
                }},
              onSubmitted: (value) {
                // summit => update or delete rule
                if (_isEdited || _textEditor.text.isEmpty) {
                  _updateRule();
                  setState(() {
                    _isEdited = false;
                  });
                }},
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
    widget.rule.detail = _textEditor.text;

    // #Case: detail is not empty
    if (widget.rule.detail.isNotEmpty) {
      widget.onUpdateRuleDetail(widget.rule);
    }

    // #Case: detail is empty;
    else {
      _deleteRule();
    }
  }

  void _deleteRule() {
    widget.onDeleteRule(widget.rule);
  }

  bool _isAdded() {
    return widget.rule.ruleId == Rule.nonAllocatedRuleId;
  }
}
