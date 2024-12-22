import 'package:flutter/material.dart';
import 'package:tripplaner/day.dart';

class TripProvider with ChangeNotifier {
  final List<Trip> _items = [];

  List<Trip> get items => _items;

  void addItem(Trip t) {
    _items.add(t);
    notifyListeners(); 
  }
}

class Trip
{
  final String name;
  final DateTime start;
  final DateTime finish;
  List<Day> days = List<Day>.empty(growable: true);
  
  int span = 0;

  Trip(this.name, this.start, this.finish)
  {
    span = finish.difference(start).inDays;
    for(int i = 0; i < span; i++)
    {
      days.add(Day(start.add(Duration(days: i)), i));
    }
  }

}

