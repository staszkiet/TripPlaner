import 'package:tripplaner/day.dart';
import 'package:tripplaner/toDoList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Trip
{
  final String name;
  final DateTime start;
  final DateTime finish;
  List<Day> days = [];
  ToDoListProvider todo = ToDoListProvider();
  String id = "";
  

  Trip(this.name, this.start, this.finish, {this.id = ""});

  factory Trip.fromJson(Map<String, dynamic> json, String dbId) {
    return Trip(
      json['name'],
      (json['start'] as Timestamp).toDate(),
      (json['finish'] as Timestamp).toDate(),
      id:dbId
    );
  }
  
  toJson()
  {
    return {
      "name": name,
      "start": start,
      "finish": finish,
    };
  }

  

}

