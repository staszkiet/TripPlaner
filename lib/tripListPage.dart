import 'package:flutter/material.dart';
import 'package:tripplaner/trip.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/tripCreationForm.dart';
import 'package:tripplaner/tripPage.dart';
class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your trips"),
                leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          }),
        actions: [
          IconButton(
              onPressed: () => print("pressed"), icon: const Icon(Icons.person))
        ],
      ),
      body: ListView.builder(
        itemCount: trips.items.length,
        itemBuilder: (context, index) {
          return TripListElement(trip: trips.items[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TripCreationForm()));
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
        constraints:
            BoxConstraints(maxHeight: 100, minHeight: 100, minWidth: 500),
        color: Colors.amber[50],
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            trip.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
              "${trip.start.day}/${trip.start.month}/${trip.start.year} - ${trip.finish.day}/${trip.finish.month}/${trip.finish.year}")
        ]),
        IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right_alt_rounded)),
      ]),
    );
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
        IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TripPage(trip: trip)),);
        }, icon: Icon(Icons.arrow_right_alt_rounded)),
      ]),
    );
  }
}
