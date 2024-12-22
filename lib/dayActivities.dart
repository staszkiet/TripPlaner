import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Attraction
{
  final String name;
  Attraction(this.name);
}

class AttractionProvider with ChangeNotifier {
  final List<Attraction> _items = [];

  List<Attraction> get items => _items;

  void addItem(Attraction a) {
    _items.add(a);
    notifyListeners(); 
  }
}
