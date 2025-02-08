import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:intl/intl.dart';
import 'package:tripplaner/components/activity_popup_menu.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

class AttractionsSmallListViewElement extends StatelessWidget {
  const AttractionsSmallListViewElement({
    super.key,
    required this.attraction,
  });
  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.pin_drop)),
          Builder(
            builder: (context) {
              if (attraction.start == null && attraction.end == null) {
                return Expanded(
                  child: Center(
                    child: Text(
                      attraction.name,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        attraction.name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          attraction.start != null
                              ? Text(
                                  "start: ${timeFormatter.format(DateTime(0, 1, 1, attraction.start!.hour, attraction.start!.minute))} ")
                              : Text(""),
                          attraction.end != null
                              ? Text(
                                  "end: ${timeFormatter.format(DateTime(0, 1, 1, attraction.end!.hour, attraction.end!.minute))}")
                              : Text(""),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ActivityPopupMenu(activity: attraction)
        ]));
  }
}

class SleepoverSmallListViewElement extends StatelessWidget {
  const SleepoverSmallListViewElement({super.key, required this.sleepover});

  final Sleepover sleepover;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.house_rounded)),
        Builder(builder: (context) {
          if (sleepover.checkin == null && sleepover.checkout == null) {
            return Expanded(
              child: Center(
                child: Text(
                  sleepover.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sleepover.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sleepover.checkin != null
                          ? Text(
                              "check-in: ${timeFormatter.format(DateTime(0, 1, 1, sleepover.checkin!.hour, sleepover.checkin!.minute))} ")
                          : Text(""),
                      sleepover.checkout != null
                          ? Text(
                              "end: ${timeFormatter.format(DateTime(0, 1, 1, sleepover.checkout!.hour, sleepover.checkout!.minute))}")
                          : Text(""),
                    ],
                  ),
                ],
              ),
            );
          }
        }),
        ActivityPopupMenu(activity: sleepover)
      ]),
    );
  }
}

class TransportSmallListViewElement extends StatelessWidget {
  const TransportSmallListViewElement({
    super.key,
    required this.transport,
  });
  final Transport transport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.all(8.0), child: Icon(Icons.airplanemode_on)),
        Flexible(child: Text("${transport.source} - ${transport.dest}")),
        ActivityPopupMenu(activity: transport)
      ]),
    );
  }
}
