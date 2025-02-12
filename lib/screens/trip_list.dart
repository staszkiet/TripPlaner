import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:tripplaner/screens/forms/trip_creation_form.dart';
import 'package:tripplaner/screens/trip_details_screen/trip_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/screens/authentication/login_screen.dart';

class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return Scaffold(
        appBar: AppBar(
          title: const Text("TripPlaner"),
          backgroundColor: Colors.blue[50],
        ),
        body: Container(
            color: Colors.blue[50],
            child: StreamBuilder(
                stream: firestoreService.getTripsStream(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                                child: Center(
                                    child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 30),
                                        child: Text("Your Trips",
                                            style: TextStyle(fontSize: 40))))),
                            SliverToBoxAdapter(
                                child: Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                            "Click arrow to see details",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey))))),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                              List trips = snapshot.data!.docs;
                              DocumentSnapshot document = trips[index];
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              Trip t = Trip.fromJson(data, document.id);
                              return Column(children: [
                                TripListElement(trip: t),
                                SizedBox(
                                  height: 20,
                                )
                              ]);
                            }, childCount: snapshot.data!.docs.length))
                          ],
                        );
                })),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
          shape: CircleBorder(),
          onPressed: () async {
            final t = await Navigator.push<Trip>(context,
                MaterialPageRoute(builder: (context) => TripCreationForm()));
            if (t != null) {
              String id = await firestoreService.addTrip(t);
              t.id = id;
            }
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            height: 60,
            color: Colors.grey,
            child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginForm()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ))));
  }
}

class TripListElement extends StatefulWidget {
  const TripListElement({super.key, required this.trip});
  final Trip trip;

  @override
  State<TripListElement> createState() => _TripListElementState();
}

class _TripListElementState extends State<TripListElement> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return Card(
          color: Colors.blue[200],
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.black, width: 2.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(children: [
                                Text(
                                  "Trip: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  widget.trip.name,
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ])),
                          Text(
                              "${widget.trip.start.day}/${widget.trip.start.month}/${widget.trip.start.year} - ${widget.trip.finish.day}/${widget.trip.finish.month}/${widget.trip.finish.year}")
                        ]),
                  ),
                  Flexible(
                    child: IconButton(
                        onPressed: () async {
                          final firestoreService = FirestoreService();
                          setState(() {
                            loading = true;
                          });
                          List<Day> d = await firestoreService
                              .fetchDaysWithAttractions(widget.trip.id);
                          widget.trip.days = d;
                          setState(() {
                            loading = false;
                          });
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TripPage(trip: widget.trip)),
                            );
                          }
                        },
                        icon: Icon(Icons.arrow_right_alt_rounded)),
                  )
                ]),
          ));
    }
  }
}
