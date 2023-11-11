import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/old_panel.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RoundInfoListWidget extends StatefulWidget {
  final int studyId;

  const RoundInfoListWidget({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<RoundInfoListWidget> createState() => RoundInfoListWidgetState();
}

class RoundInfoListWidgetState extends State<RoundInfoListWidget> {
  late final GlobalKey<AnimatedListState> _roundListKey = GlobalKey<AnimatedListState>();
  late final ListModel<Round> _roundListModel;
  @override
  void initState() {
    super.initState();
    _roundListModel = ListModel<Round>(
      listKey: _roundListKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Round.getRoundInfoResponses(widget.studyId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != _roundListModel.items) {
            _roundListModel.setItems(snapshot.data!);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(title: "ROUND LIST", icon: OldAppIcons.add, onTap: _addNewRound),
              AnimatedList(
                key: _roundListKey,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,

                initialItemCount: _roundListModel.length,
                itemBuilder: _buildItem,
              ),
            ]
          );
        }
        return OldDesign.loadingIndicator;
      });
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    int roundSeq = _roundListModel.length - index;
    return OldPanel(
      boxShadows: OldDesign.basicShadows,
      onTap: () => _viewRound(roundSeq, index),
      child: SizeTransition(
        sizeFactor: animation,
        child: RoundInfoWidget(
          roundSeq: roundSeq,
          round: _roundListModel[index],
          studyId: widget.studyId,
        ),
      ),
    );
  }

  Future<ListModel<Round>> getRound() async {
    List<Round> rounds = await Round.getRoundInfoResponses(widget.studyId);
    return ListModel(
      listKey: _roundListKey,
      items: rounds,
    );
  }

  void _viewRound(int roundSeq, int index) async {
    if (_roundListModel[index].roundId == Round.nonAllocatedRoundId) {
      await Round.createRound(_roundListModel[index], widget.studyId);
    }

    if (mounted) {
      Util.pushRoute(context, (context) =>
          RoundDetailRoute(
            roundSeq: roundSeq,
            roundId: _roundListModel[index].roundId,
            studyId: widget.studyId,));
    }
  }

  void _addNewRound() {
    _roundListModel.insert(0, Round(
      roundId: Round.nonAllocatedRoundId,
    ));
  }
}