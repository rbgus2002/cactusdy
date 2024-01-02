
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/rule.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/list_model.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/add_button.dart';
import 'package:groupstudy/widgets/rules/rule_widget.dart';

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
  static const int _ellipsisCount = 3;
  static const double _ruleWidgetHeight = 40;
  static const double _iconSize = 24;

  late GlobalKey<AnimatedListState> _rulesKey;
  late ListModel<Rule> _ruleListModel;

  late final bool _isFoldable;
  bool _expended = false;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initListModel();

    // it is only once distinguished at first
    _isFoldable = (_ruleListModel.length >= _ellipsisCount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _titleWidget(),
        Design.padding(6),
        
        _ruleList(),
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
  
  Widget _ruleList() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Rule List
        AnimatedContainer(
          height: (_expended)?
            (_ruleListModel.length * _ruleWidgetHeight + ((_isFoldable)? _iconSize : 0) ) :
            (min(_ruleListModel.length, _ellipsisCount) * _ruleWidgetHeight),
          duration: AnimationSetting.animationDurationShort,
          curve: Curves.easeOutCirc,
          child: AnimatedList(
            key: _rulesKey,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            initialItemCount: _ruleListModel.length,
            itemBuilder: _buildRule,),),

        // Overlay Shadow
        Visibility(
          visible: _isFoldable,
          child: _overlayShadow(),),
      ],
    );
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

  Widget _overlayShadow() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _expend,
      child: AnimatedContainer(
        duration: AnimationSetting.animationDurationShort,
        curve: Curves.easeOutCirc,

        width: double.maxFinite,
        height: (_expended)?
        _iconSize : (min(_ruleListModel.length, _ellipsisCount) * 40),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [
              0.5,
              0.95,
            ],
            colors: [
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
              Theme.of(context).scaffoldBackgroundColor,
            ],),),
        child: AnimatedRotation(
          duration: AnimationSetting.animationDurationShort,
          curve: Curves.easeOutCirc,
          turns: (_expended)? 0.5 : 0,
          child: Icon(
            CustomIcons.chevron_down,
            size: _iconSize,
            color: context.extraColors.grey500,),),
      ),
    );
  }

  Widget _buildRule(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: RuleWidget(
          enable: _isEnable(),
          rule: _ruleListModel[index],
          height: _ruleWidgetHeight,
          onUpdateRuleDetail: _updateRuleDetail,
          onDeleteRule: (rule) => _deleteRule(rule, index),));
  }

  Widget _buildRemovedItem(
      Rule rule, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: RuleWidget(
          enable: _isEnable(),
          rule: rule,
          height: _ruleWidgetHeight,
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
    if (!_expended) {
      setState(() => _expended = true);
    }

    if (_isAddable()) {
      if (!_isProcessing && _isNotAdded()) {
        _isProcessing = true;

        setState(() {
          _ruleListModel.add(Rule());
          _isProcessing = false;
        });
      }
    }

    else {
      Toast.showToast(
          context: context,
          message: context.local.ruleIsLimitedTo(Rule.ruleLimitedCount));
    }
  }

  bool _isEnable() {
    return (_ruleListModel.length < _ellipsisCount || _expended);
  }

  void _expend() {
    setState(() => _expended = !_expended);
  }

  void _updateRuleDetail(Rule rule) {
    // #Case : added new rule
    if (rule.ruleId == Rule.nonAllocatedRuleId) {
      Rule.createRule(rule, widget.studyId);
    }

    // #Case : modified the task
    else {
      Rule.updateRuleDetail(rule);
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

  bool _isAddable() {
    return _ruleListModel.length < Rule.ruleLimitedCount;
  }

  bool _isNotAdded() {
    return (_ruleListModel.items.isEmpty ||
        (_ruleListModel.items.last.ruleId != Rule.nonAllocatedRuleId));
  }
}
