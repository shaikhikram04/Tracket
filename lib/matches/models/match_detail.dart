import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracket/matches/models/match.dart';

class MatchDetail {
  const MatchDetail({
    required this.schedule,
    required this.venue,
    required this.overs,
  });
  final MatchFormat overs;
  final String venue;
  final DateTime schedule;

  Map<String, dynamic> get toMap => {
        'schedule': Timestamp.fromDate(schedule),
        'venue': venue,
        'overs': overs.name,
      };
}