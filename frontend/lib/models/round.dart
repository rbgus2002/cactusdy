

import 'package:group_study_app/models/participantSummary.dart';

class Round {
  final int roundId;
  final int roundIdx;
  String? place;
  DateTime? date;
  final String? tag;
  final List<ParticipantSummary>? participants;

  Round({
    required this.roundId,
    required this.roundIdx,
    this.place,
    this.date,
    this.tag,
    this.participants,
  });

  static Future<List<Round>> getRoundList(int studyId) async {
    List<Round> rounds = [
      Round(roundId: -1, roundIdx: 3,),
      Round(roundId: -1, roundIdx: 2,),
      Round(roundId: -1, roundIdx: 1,),
      Round(roundId: -1, roundIdx: 1,),
      Round(roundId: -1, roundIdx: 1,),
      Round(roundId: -1, roundIdx: 1,),
    ];

    return rounds;
  }

}