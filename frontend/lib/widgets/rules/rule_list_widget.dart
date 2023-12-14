
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_study_app/models/rule.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/widgets/buttons/add_button.dart';
import 'package:group_study_app/widgets/rules/rule_widget.dart';

class RuleListWidget extends StatefulWidget {
  final List<Rule> rules;
  final int studyId;

  const RuleListWidget({
    Key? key,
    required this.rules,
    required this.studyId,
  }) : super(key: key);

  @override
  State<RuleListWidget> createState() => _RuleListWidgetState();
}

class _RuleListWidgetState extends State<RuleListWidget> {
  late GlobalKey<AnimatedListState> _rulesKey;
  late ListModel<Rule> _ruleListModel;

  @override
  void initState() {
    super.initState();
    _initListModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _titleWidget(),
        Design.padding(6),

        AnimatedList(
          key: _rulesKey,
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          initialItemCount: _ruleListModel.length,
          itemBuilder: _buildRule,),
        Design.padding(2),
      ]);
  }

  @override
  void didUpdateWidget(covariant RuleListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_ruleListModel.items != widget.rules) {
      _initListModel();
    }
  }

  Widget _buildRule(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: RuleWidget(
          rule: _ruleListModel[index],
          onUpdateRuleDetail: _updateRuleDetail,
          onDeleteRule: (rule) => _deleteRule(rule, index),));
  }

  Widget _buildRemovedItem(
      Rule rule, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: RuleWidget(
          rule: rule,
          onUpdateRuleDetail: _updateRuleDetail,
          onDeleteRule: (rule) => _deleteRule(rule, -1),));
  }

  void _initListModel() {
    _rulesKey = GlobalKey<AnimatedListState>();
    _ruleListModel = ListModel<Rule>(
        listKey: _rulesKey,
        items: widget.rules,
        removedItemBuilder: _buildRemovedItem,);
  }

  void _addRule() {
    HapticFeedback.lightImpact();
    if (_ruleListModel.length < Rule.ruleLimitedCount) {
      _ruleListModel.add(Rule());
      setState(() {});
    }
    else {
      Toast.showToast(
          context: context,
          message: context.local.ruleIsLimitedTo(Rule.ruleLimitedCount));
    }
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.local.rules,
          style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
        AddButton(
            iconData: CustomIcons.writing_outline,
            text: context.local.writeRule,
            onTap: () => _addRule()),
      ],
    );
  }

  void _updateRuleDetail(Rule rule) {
    // #Case : added new rule
    if (rule.ruleId == Rule.nonAllocatedRuleId) {
      Rule.createRule(rule, widget.studyId);
    }

    // #Case : modified the task
    else {
      Rule.updateTaskDetail(rule);
    }
  }

  void _deleteRule(Rule rule, int index) {
    if (!_isValidIndex(index)) return;

    if (rule.ruleId != Rule.nonAllocatedRuleId) {
      Rule.deleteRule(rule);
    }

    _ruleListModel.removeAt(index);
    setState(() { });
  }

  bool _isValidIndex(int index) {
    return (index >= 0 && index < _ruleListModel.length);
  }
}
