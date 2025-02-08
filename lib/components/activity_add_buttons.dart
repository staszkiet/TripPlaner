import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:tripplaner/screens/forms/attraction_creation_form.dart';
import 'package:tripplaner/screens/forms/sleepover_creation_form.dart';
import 'package:tripplaner/screens/forms/transport_creation_form.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:tripplaner/models/activities.dart';

class TransportAddButton extends StatelessWidget {
  const TransportAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen: false);
    return TextButton(
        onPressed: () async {
          final a = await Navigator.push<Transport>(
              context,
              MaterialPageRoute(
                builder: (context) => TransportCreationForm(),
              ));
          if (a != null) {
            String id =
                await FirestoreService().addTransport(trip.id, day.id, a);
            a.id = id;
          }
        },
        child: Text("Add transport"));
  }
}

class SleepoverAddButton extends StatelessWidget {
  const SleepoverAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen: false);
    return TextButton(
        onPressed: () async {
          final a = await Navigator.push<Sleepover?>(
              context,
              MaterialPageRoute(
                builder: (context) => SleepoverCreationForm(),
              ));
          if (a != null) {
            final s = await FirestoreService().addSleepover(trip.id, day.id, a);
            a.id = s;
          }
        },
        child: Text("Add sleepover"));
  }
}

class AttractionAddButton extends StatelessWidget {
  const AttractionAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen: false);
    return TextButton(
        onPressed: () async {
          final a = await Navigator.push<Attraction>(
              context,
              MaterialPageRoute(
                builder: (context) => AttractionCreationForm(),
              ));
          if (a != null) {
            final s =
                await FirestoreService().addAttraction(trip.id, day.id, a);
            a.id = s;
          }
        },
        child: Text("Add atraction"));
  }
}
