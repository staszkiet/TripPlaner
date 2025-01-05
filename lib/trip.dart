import 'package:flutter/material.dart';
import 'package:tripplaner/day.dart';
import 'package:tripplaner/toDoList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripProvider with ChangeNotifier {
  List<Trip> items = [];

  final _db = FirebaseFirestore.instance;

  TripProvider({List<Trip>? items})
  {
    if(items != null)
    {
        this.items = items;
    }
  }

  void addItem(Trip t) {
    _db.collection("Trips").add(t.toJson());
    items.add(t);
    notifyListeners(); 
  }

  void deleteItem(Trip t){
    items.remove(t);
    notifyListeners();
  }
}

class Trip
{
  final String name;
  final DateTime start;
  final DateTime finish;
  DaysProvider daysProvider = DaysProvider();
  ToDoListProvider todo = ToDoListProvider();
  String id = "";
  
  int span = 0;

  Trip(this.name, this.start, this.finish)
  {
    span = finish.difference(start).inDays;
    for(int i = 0; i <= span; i++)
    {
      daysProvider.addItem(Day(start.add(Duration(days: i)), i));
    }
  }

  Trip.fromdb({required this.name, required this.start, required this.finish, required List<Day> days, required List<ToDoElement> done, required List<ToDoElement> todo})
  {
    daysProvider.items = days;
    this.todo.doneElements = done;
    this.todo.doneElements = todo;
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip.fromdb(
      name: json['name'],
      start: (json['start'] as Timestamp).toDate(),
      finish: (json['finish'] as Timestamp).toDate(),
      days: (json['days'] as List).map((day) => Day.fromJson(day)).toList(),
      done: (json['done'] as List).map((element) => ToDoElement.fromJson(element)).toList(),
      todo: (json['todo'] as List).map((element) => ToDoElement.fromJson(element)).toList(),
    );
  }
  
  toJson()
  {
    return {
      "name": name,
      "start": start,
      "finish": finish,
      "days": daysProvider.items.map((day) => day.toJson()).toList(),
      "done": todo.doneElements,
      "todo": todo.notDoneElements
    };
  }

  

}

