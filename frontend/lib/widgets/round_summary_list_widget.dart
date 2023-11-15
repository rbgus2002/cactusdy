import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/widgets/buttons/add_button.dart';
import 'package:group_study_app/widgets/round_summary_widget.dart';

class RoundSummaryListWidget extends StatefulWidget {
  final int studyId;
  final Color studyColor;

  const RoundSummaryListWidget({
    Key? key,
    required this.studyId,
    required this.studyColor,
  }) : super(key: key);

  @override
  State<RoundSummaryListWidget> createState() => RoundSummaryListWidgetState();
}

class RoundSummaryListWidgetState extends State<RoundSummaryListWidget> {
  late GlobalKey<AnimatedListState> _roundListKey;
  late ListModel<Round> _roundListModel;

  @override
  void initState() {
    super.initState();
    _initListModel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.local.roundList ,
              style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
            AddButton(
                iconData: CustomIcons.plus_square_outline,
                text: context.local.addRound,
                onTap: _addNewRound),
          ],),
        Design.padding20,

        FutureBuilder(
          future: Round.getRoundInfoResponses(widget.studyId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != _roundListModel.items) {
                _initListModel(rounds: snapshot.data!);
              }

              return AnimatedList(
                padding: EdgeInsets.zero,
                key: _roundListKey,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,

                initialItemCount: _roundListModel.length,
                itemBuilder: _buildItem,);
            }
            return Design.loadingIndicator;
          }),
      ],
    );
  }

  void _initListModel({ List<Round>? rounds }) {
    _roundListKey = GlobalKey<AnimatedListState>();
    _roundListModel = ListModel(
        listKey: _roundListKey,
        items: rounds??[]);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    int roundSeq = _roundListModel.length - index;
    return SizeTransition(
        sizeFactor: animation,
        child: RoundSummaryWidget(
          roundSeq: roundSeq,
          round: _roundListModel[index],
          studyId: widget.studyId,
          studyColor: widget.studyColor,),
    );
  }

  Future<ListModel<Round>> getRound() async {
    List<Round> rounds = await Round.getRoundInfoResponses(widget.studyId);
    return ListModel(
      listKey: _roundListKey,
      items: rounds,
    );
  }

  void _addNewRound() {
    _roundListModel.insert(0, Round(
        roundId: Round.nonAllocatedRoundId,));
  }
}