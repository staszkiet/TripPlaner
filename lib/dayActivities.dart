import 'package:flutter/material.dart';
class Attraction
{
  final String name;
  TimeOfDay? start, end;
  double price;
  String currency;
  Attraction(this.name, {this.start, this.end, this.price = 0, this.currency = "zl"});
}

class AttractionProvider with ChangeNotifier {
  final List<Attraction> _items = [];

  List<Attraction> get items => _items;

  void addItem(Attraction a) {
    _items.add(a);
    notifyListeners(); 
  }
}

class Sleepover
{
  final String name;
  double price;
  String currency;
  TimeOfDay? checkin, checkout;
  Sleepover(this.name, {this.price = 0, this.currency = "zl", this.checkin, this.checkout});
}

class SleepoverProvider with ChangeNotifier {
  Sleepover? _sleepover;

  Sleepover? get sleepover => _sleepover;

  void changeSleepover(Sleepover s) {
    _sleepover = s;
    notifyListeners(); 
  }
}

class Transport
{
  final String source;
  final String dest;
  Transport({required this.source, required this.dest});
}

class TransportProvider with ChangeNotifier {
  final List<Transport> _items = [];

  List<Transport> get items => _items;

  void addItem(Transport t) {
    _items.add(t);
    notifyListeners(); 
  }
}