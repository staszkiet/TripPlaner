import 'package:flutter/material.dart';
import 'package:tripplaner/screens/todo_list.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/screens/trip_map_view.dart';
import 'package:intl/intl.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:tripplaner/models/day.dart';
import 'day_element.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

class TripPage extends StatefulWidget {
  const TripPage({super.key, required this.trip});
  final Trip trip;

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.trip.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.blue[50],
                child: StreamBuilder(
                  stream: FirestoreService()
                      .getDaysStream(widget.trip.id), // Stream of days
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error loading days"));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text("No days available for this trip"));
                    }

                    final days = snapshot.data!.docs.map((doc) {
                      return Day.fromJson(
                          doc.data() as Map<String, dynamic>, doc.id);
                    }).toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                widget.trip.name,
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                          ...days.map((day) {
                            return Provider<Trip>.value(
                              value: widget.trip,
                              child: Column(
                                children: [
                                  DayWidget(day: day),
                                  SizedBox(height: 20),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  },
                ),
              ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            color: Colors.grey,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        widget.trip.days = await FirestoreService()
                            .fetchDaysWithAttractions(widget.trip.id);
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TripMapView(t: widget.trip)));
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      icon: Icon(Icons.map_outlined)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ToDoListPage(
                                tripId: widget.trip.id,
                              ),
                            ));
                      },
                      icon: Icon(Icons.list)),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text(
                                'Are you sure you want to delete this trip?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirestoreService().deletetrip(widget.trip);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  )
                ])));
  }
}
