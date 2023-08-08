
class RoundParticipantInfo {
  final int roundParticipantId;
  final int userId;
  final String picture;
  final String statusTag;

  RoundParticipantInfo({
    required this.roundParticipantId,
    required this.userId,
    required this.picture,
    required this.statusTag,
  });

  factory RoundParticipantInfo.fromJson(Map<String, dynamic> json) {
    return RoundParticipantInfo(
        roundParticipantId: json['roundParticipantId'],
        userId: json['userId'],
        picture: json['picture'],
        statusTag: json['statusTag'],
    );
  }
}
