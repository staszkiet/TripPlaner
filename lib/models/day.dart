import 'package:tripplaner/models/activities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Day {
  final DateTime dayDate;
  final int index;
  List<Attraction> attractions = [];
  List<Transport> transport = [];
  List<Sleepover> sleepovers = [];
  List<String> images = [];
  String id;

  Day(this.dayDate, this.index, {this.id = ""});

  factory Day.fromJson(Map<String, dynamic> json, String id) {
    Day d = Day((json['dayDate'] as Timestamp).toDate(), json['index'] as int,
        id: id);
    return d;
  }
  toJson() {
    return {
      "dayDate": dayDate,
      "index": index,
    };
  }
}
