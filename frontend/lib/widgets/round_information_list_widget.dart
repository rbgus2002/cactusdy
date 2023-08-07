import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_information_widget.dart';

class RoundInformationListWidget extends StatefulWidget {
  final int studyId;

  const RoundInformationListWidget({
    super.key,
    required this.studyId,
  });

  @override
  State<RoundInformationListWidget> createState() => RoundInformationListWidgetState();
}

class RoundInformationListWidgetState extends State<RoundInformationListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final Future<ListModel<Round>> _listModel;
  late ListModel<Round> _rounds;

  @override
  void initState() {
    super.initState();
    _listModel = getRound();
  }

  @override
  Widget build(BuildContext context) {
    print(Colors.blue.toString());
    return FutureBuilder(
      future: _listModel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _rounds = snapshot.data!;

          return AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,

            initialItemCount: _rounds.length,
            itemBuilder: (context, index, animation) {
              return Panel(
                boxShadows: Design.basicShadows,
                onTap: () {
                  Util.pushRoute(context, (context) => RoundDetailRoute());
                },
                child: RoundInformationWidget(round: _rounds[index], animation: animation),
              );
            },
          );
        }
        else {
          return const CircularProgressIndicator();
        }
      }
    );
  }

  Future<ListModel<Round>> getRound() async {
    final List<Round> rounds = await Round.getRoundList(widget.studyId);
    return ListModel(
      listKey: _listKey,
      initialItems: rounds,
    );
  }

  void addNewRound() {
    setState(() {
      _rounds.insert(0, Round(roundIdx: 4, roundId: 1));
    });
  }
}