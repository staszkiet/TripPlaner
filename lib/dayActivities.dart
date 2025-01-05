import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

sealed class Activity{}

class Attraction extends Activity
{
  final String name;
  TimeOfDay? start, end;
  double price;
  String currency;
  LatLng? location;
  Attraction(this.name, {this.start, this.end, this.price = 0, this.currency = "zl", this.location});

    factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      json['name'],
      start: json['start'] != null
          ? TimeOfDay(hour: json['start']['hour'], minute: json['start']['minute'])
          : null,
      end: json['end'] != null
          ? TimeOfDay(hour: json['end']['hour'], minute: json['end']['minute'])
          : null,
      price: json['price']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? "zl",
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      "name": name,
      "start": start != null ? {"hour": start!.hour, "minute": start!.minute} : null,
      "end": end != null ? {"hour": end!.hour, "minute": end!.minute} : null,
      "price": price,
      "currency": currency,
      "location": location != null
          ? {"latitude": location!.latitude, "longitude": location!.longitude}
          : null,
    };
  }
}

class AttractionProvider with ChangeNotifier {
  List<Attraction> items = [];

  void addItem(Attraction a) {
    items.add(a);
    notifyListeners(); 
  }

  void deleteItem(Attraction a)
  {
    items.remove(a);
    notifyListeners();
  }

  void replaceItem(Attraction incoming, Attraction out)
  {
    int idx = items.indexOf(out);
    items[idx] = incoming;
    notifyListeners();
  }
}

class Sleepover extends Activity
{
  final String name;
  double price;
  String currency;
  TimeOfDay? checkin, checkout;
  LatLng? location;
  Sleepover(this.name, {this.price = 0, this.currency = "zl", this.checkin, this.checkout, this.location});

    factory Sleepover.fromJson(Map<String, dynamic> json) {
    return Sleepover(
      json['name'],
      price: json['price']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? "zl",
      checkin: json['checkin'] != null
          ? TimeOfDay(hour: json['checkin']['hour'], minute: json['checkin']['minute'])
          : null,
      checkout: json['checkout'] != null
          ? TimeOfDay(hour: json['checkout']['hour'], minute: json['checkout']['minute'])
          : null,
      location: json['location'] != null
          ? LatLng(json['location']['latitude'], json['location']['longitude'])
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "currency": currency,
      "checkin": checkin != null ? {"hour": checkin!.hour, "minute": checkin!.minute} : null,
      "checkout": checkout != null ? {"hour": checkout!.hour, "minute": checkout!.minute} : null,
      "location": location != null
          ? {"latitude": location!.latitude, "longitude": location!.longitude}
          : null,
    };
  }
}

class SleepoverProvider with ChangeNotifier {
  Sleepover? sleepover;


  void changeSleepover(Sleepover s) {
    sleepover = s;
    notifyListeners(); 
  }

  void deleteItem()
  {
    sleepover = null;
    notifyListeners();
  }
}

class Transport extends Activity
{
  final String source;
  final String dest;
  LatLng? sourceLocation;
  LatLng? destLocation;
  Transport({required this.source, required this.dest, this.sourceLocation, this.destLocation});

    factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      source: json['source'],
      dest: json['dest'],
      sourceLocation: json['sourceLocation'] != null
          ? LatLng(json['sourceLocation']['latitude'], json['sourceLocation']['longitude'])
          : null,
      destLocation: json['destLocation'] != null
          ? LatLng(json['destLocation']['latitude'], json['destLocation']['longitude'])
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      "source": source,
      "dest": dest,
      "sourceLocation": sourceLocation != null
          ? {"latitude": sourceLocation!.latitude, "longitude": sourceLocation!.longitude}
          : null,
      "destLocation": destLocation != null
          ? {"latitude": destLocation!.latitude, "longitude": destLocation!.longitude}
          : null,
    };
  }
}

class TransportProvider with ChangeNotifier {
  List<Transport> items = [];


  void addItem(Transport t) {
    items.add(t);
    notifyListeners(); 
  }

  void deleteItem(Transport t)
  {
    items.remove(t);
    notifyListeners();
  }

  void replaceItem(Transport incoming, Transport out)
  {
    int idx = items.indexOf(out);
    items[idx] = incoming;
    notifyListeners();
  }
}