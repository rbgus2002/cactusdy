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
  late final ListModel<Round> _roundListModel;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRound(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _roundListModel = snapshot.data!;
          _isInit = true;

          return AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,

            initialItemCount: _roundListModel.length,
            itemBuilder: _buildItem,
          );
        }

        return Design.loadingIndicator;
      }
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    int roundNum = _roundListModel.length - index;
    return Panel(
      boxShadows: Design.basicShadows,
      onTap: () {
        if (_roundListModel[index].roundId == Round.nonAllocatedRoundId) {
          Round.createRound(_roundListModel[index], widget.studyId).then((value) =>
              Util.pushRoute(context, (context) =>
                  RoundDetailRoute(
                      roundNum: roundNum, roundId: _roundListModel[index].roundId)));
        }
        else {
          Util.pushRoute(context, (context) =>
              RoundDetailRoute(
                  roundNum: roundNum, roundId: _roundListModel[index].roundId));
        }
      },
      child: SizeTransition(
        sizeFactor: animation,
        child: RoundInfoWidget(
          roundNum: roundNum,
          round: _roundListModel[index],
          onUpdateRound: onUpdateRound,
        ),
      ),
    );
  }

  void onUpdateRound(Round round) {
    if (round.roundId == Round.nonAllocatedRoundId) {
      Round.createRound(round, widget.studyId);
    }
    else {
      Round.updateAppointment(round);
    }
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
      _roundListModel.insert(0, Round(
        roundId: Round.nonAllocatedRoundId,
      ));
    }
  }
}