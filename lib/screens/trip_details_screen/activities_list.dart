import 'package:flutter/material.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/models/activities.dart';
import 'activity_elements.dart';
import 'package:tripplaner/components/activity_add_buttons.dart';

class AttractionsListUnderDay extends StatelessWidget {
  AttractionsListUnderDay({super.key});

  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen: false);
    return Column(children: [
      Divider(color: Colors.black),
      Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              "Attractions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )),
      StreamBuilder(
          stream: firestoreService.getAttractionsStream(trip.id, day.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final attractions = snapshot.data!.docs;
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: attractions.length,
                itemBuilder: (context, index) {
                  return AttractionsSmallListViewElement(
                    attraction: Attraction.fromJson(
                        attractions[index].data() as Map<String, dynamic>,
                        attractions[index].id),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
              );
            } else {
              return Text("no attractions");
            }
          }),
      Align(alignment: Alignment.centerRight, child: AttractionAddButton()),
      Divider(color: Colors.black),
      Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              "Sleepover",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )),
      StreamBuilder(
          stream: firestoreService.getSleepoversStream(trip.id, day.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final sleepovers = snapshot.data!.docs;
              return ListView.separated(
                shrinkWrap: true,
                itemCount: sleepovers.length,
                itemBuilder: (context, index) {
                  return SleepoverSmallListViewElement(
                    sleepover: Sleepover.fromJson(
                        sleepovers[index].data() as Map<String, dynamic>,
                        sleepovers[index].id),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
              );
            } else {
              return Text("no sleepovers");
            }
          }),
      Align(alignment: Alignment.centerRight, child: SleepoverAddButton()),
      Divider(color: Colors.black),
      Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              "Transport",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )),
      StreamBuilder(
          stream: firestoreService.getTransportsStream(trip.id, day.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final transports = snapshot.data!.docs;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: transports.length,
                  itemBuilder: (context, index) {
                    return TransportSmallListViewElement(
                      transport: Transport.fromJson(
                          transports[index].data() as Map<String, dynamic>,
                          transports[index].id),
                    );
                  });
            } else {
              return Text("no transports");
            }
          }),
      Align(alignment: Alignment.centerRight, child: TransportAddButton()),
    ]);
  }
}
