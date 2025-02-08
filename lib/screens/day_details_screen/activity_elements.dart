import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:tripplaner/screens/trip_details_screen/trip_page.dart';
import 'package:tripplaner/components/activity_popup_menu.dart';

class AttractionsWidget extends StatelessWidget {
  const AttractionsWidget({super.key, required this.attraction});

  final Attraction attraction;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
            color: Colors.blue[200],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(8.0), child: Icon(Icons.pin_drop)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        attraction.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          "start: ${attraction.start == null ? "??" : timeFormatter.format(DateTime(0, 1, 1, attraction.start!.hour, attraction.start!.minute))}"),
                      Text(
                          "end: ${attraction.end == null ? "??" : timeFormatter.format(DateTime(0, 1, 1, attraction.end!.hour, attraction.end!.minute))}"),
                      Text(
                          "cost: ${attraction.price.toStringAsFixed(2)} ${attraction.currency}")
                    ],
                  ),
                ),
                ActivityPopupMenu(activity: attraction)
              ],
            )));
  }
}

class SleepoverWidget extends StatelessWidget {
  const SleepoverWidget({super.key, required this.sleepover});
  final Sleepover sleepover;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
            color: Colors.green[200],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.house)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(sleepover.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          "check-in: ${sleepover.checkin == null ? "??" : timeFormatter.format(DateTime(0, 1, 1, sleepover.checkin!.hour, sleepover.checkin!.minute))}"),
                      Text(
                          "checkout: ${sleepover.checkout == null ? "??" : timeFormatter.format(DateTime(0, 1, 1, sleepover.checkout!.hour, sleepover.checkout!.minute))}"),
                      Text(
                          "cost: ${sleepover.price.toStringAsFixed(2)} ${sleepover.currency}")
                    ],
                  ),
                ),
                ActivityPopupMenu(activity: sleepover)
              ],
            )));
  }
}

class TransportWidget extends StatelessWidget {
  const TransportWidget({super.key, required this.transport});
  final Transport transport;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
            color: Colors.orange[200],
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.route)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text("source: ${transport.source}"),
                      Text("dest: ${transport.dest}"),
                    ],
                  ),
                ),
                ActivityPopupMenu(activity: transport)
              ],
            )));
  }
}
