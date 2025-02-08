import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:tripplaner/screens/forms/attraction_creation_form.dart';
import 'package:tripplaner/screens/forms/sleepover_creation_form.dart';
import 'package:tripplaner/screens/forms/transport_creation_form.dart';

class ActivityPopupMenu extends StatelessWidget {
  const ActivityPopupMenu({super.key, required this.activity});
  final Activity activity;
  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen: false);
    switch (activity) {
      case Attraction():
        {
          Attraction attraction = activity as Attraction;
          return PopupMenuButton(
              onSelected: (value) async {
                if (value == "delete") {
                  FirestoreService()
                      .deleteAttraction(trip.id, day.id, attraction.id);
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttractionCreationForm(
                          toEdit: attraction,
                        ),
                      ));
                  FirestoreService()
                      .updateAttraction(trip.id, day.id, attraction, a);
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "delete", child: Center(child: Text("delete"))),
                    PopupMenuItem(
                        value: "edit", child: Center(child: Text("edit")))
                  ]);
        }
      case Sleepover():
        {
          Sleepover sleepover = activity as Sleepover;
          return PopupMenuButton(
              onSelected: (value) async {
                if (value == "delete") {
                  FirestoreService()
                      .deleteSleepover(trip.id, day.id, sleepover.id);
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepoverCreationForm(
                          toEdit: sleepover,
                        ),
                      ));
                  FirestoreService()
                      .updateSleepover(trip.id, day.id, sleepover, a);
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "delete", child: Center(child: Text("delete"))),
                    PopupMenuItem(
                        value: "edit", child: Center(child: Text("edit")))
                  ]);
        }
      case Transport():
        {
          Transport transport = activity as Transport;
          return PopupMenuButton(
              onSelected: (value) async {
                if (value == "delete") {
                  FirestoreService()
                      .deleteTransport(trip.id, day.id, transport.id);
                } else {
                  final a = await Navigator.push<Transport?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransportCreationForm(
                          toEdit: transport,
                        ),
                      ));
                  if (a != null) {
                    FirestoreService()
                        .updateTransport(trip.id, day.id, transport, a);
                  }
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "delete", child: Center(child: Text("delete"))),
                    PopupMenuItem(
                        value: "edit", child: Center(child: Text("edit")))
                  ]);
        }
    }
  }
}
