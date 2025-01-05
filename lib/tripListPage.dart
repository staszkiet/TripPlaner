import 'package:flutter/material.dart';
import 'package:tripplaner/firestore.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/tripCreationForm.dart';
import 'package:tripplaner/tripPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final trips = context.watch<TripProvider>();
    final firestoreService = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your trips"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getTrips(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "No active trips",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              List trips = snapshot.data!.docs;
              return ListView.separated(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = trips[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  Trip t = Trip.fromJson(data);
                  t.id = document.id;
                  return TripListElement(trip: t);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final t = await Navigator.push<Trip>(context,
              MaterialPageRoute(builder: (context) => TripCreationForm()));
          if (t != null) {
           await firestoreService.addTrip(t);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TripListElement extends StatelessWidget {
  const TripListElement({required this.trip, super.key});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 100),
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return TripListElementWideLayout(trip: trip);
          } else {
            return TripListElementNarrowLayout(trip: trip);
          }
        }));
  }
}

class TripListElementNarrowLayout extends StatelessWidget {
  const TripListElementNarrowLayout({super.key, required this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.amber[50],
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(30),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        trip.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Text(
                        "${trip.start.day}/${trip.start.month}/${trip.start.year} - ${trip.finish.day}/${trip.finish.month}/${trip.finish.year}")
                  ]),
            ),
            Flexible(
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripPage(trip: trip)),
                    );
                  },
                  icon: Icon(Icons.arrow_right_alt_rounded)),
            )
          ]),
        ));
  }
}

class TripListElementWideLayout extends StatelessWidget {
  const TripListElementWideLayout({super.key, required this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          trip.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(
            "${trip.start.day}/${trip.start.month}/${trip.start.year} - ${trip.finish.day}/${trip.finish.month}/${trip.finish.year}"),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripPage(trip: trip)),
              );
            },
            icon: Icon(Icons.arrow_right_alt_rounded)),
      ]),
    );
  }
}
