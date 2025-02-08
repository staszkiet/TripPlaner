import 'todo_element.dart';
import 'day.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String name;
  final DateTime start;
  final DateTime finish;
  List<Day> days = [];
  List<ToDoElement> todo = [];
  String id = "";

  Trip(this.name, this.start, this.finish, {this.id = ""}) {
    final span = finish.difference(start).inDays;
    for (int i = 0; i <= span; i++) {
      days.add(Day(start.add(Duration(days: i)), i));
    }
  }

  factory Trip.fromJson(Map<String, dynamic> json, String dbId) {
    return Trip(json['name'], (json['start'] as Timestamp).toDate(),
        (json['finish'] as Timestamp).toDate(),
        id: dbId);
  }

  toJson() {
    return {
      "name": name,
      "start": start,
      "finish": finish,
    };
  }
}
