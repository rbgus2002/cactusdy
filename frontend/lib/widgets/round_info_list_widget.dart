import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';

class RoundInfoListWidget extends StatefulWidget {
  final int studyId;

  const RoundInfoListWidget({
    super.key,
    required this.studyId,
  });

  @override
  State<RoundInfoListWidget> createState() => RoundInfoListWidgetState();
}

class RoundInfoListWidgetState extends State<RoundInfoListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final Future<ListModel<Round>> _listModel;
  late final ListModel<Round> _rounds;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _listModel = getRound();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listModel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _rounds = snapshot.data!;
          _isInit = true;

          return AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,

            initialItemCount: _rounds.length,
            itemBuilder: _buildItem,
          );
        }

        return Design.loadingIndicator;
      }
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    int _roundNum = _rounds.length - index;
    return Panel(
      boxShadows: Design.basicShadows,
      onTap: () {
        Util.pushRoute(context, (context) =>
            RoundDetailRoute(roundNum: _roundNum, roundId: _rounds[index].roundId));
      },
      child: SizeTransition(
        sizeFactor: animation,
        child: RoundInfoWidget(
          studyId: widget.studyId,
          roundNum: _roundNum,
          round: _rounds[index],
        ),
      ),
    );
  }

  Future<ListModel<Round>> getRound() async {
    List<Round> rounds = await Round.getRoundInfoResponses(widget.studyId);
    return ListModel(
      listKey: _listKey,
      initialItems: rounds,
    );
  }

  void addNewRound() {
    if (_isInit) {
      _rounds.insert(0, Round(
        roundId: Round.nonAllocatedRoundId,
      ));
    }
  }
}