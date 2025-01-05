import 'package:flutter/material.dart';
import 'package:tripplaner/toDoList.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:tripplaner/activityCreationForms.dart';
import 'package:tripplaner/tripMapView.dart';
import 'package:intl/intl.dart';
import 'package:tripplaner/firestore.dart';

class TripPage extends StatelessWidget {
  const TripPage({super.key, required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                              value: trip.todo,
                              child: ToDoListPage(
                                tripId: trip.id,
                              ),
                            )));
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: ListView.separated(
        itemCount: trip.days.length,
        itemBuilder: (context, index) => Provider<Trip>.value(value:trip, child: DayWidget(
            day: trip.days[index],
        )),
        separatorBuilder: (context, index) => SizedBox(height: 20),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            trip.days =
                await FirestoreService().fetchDaysWithAttractions(trip.id);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => tripMapView(t: trip)));
          },
          child: Icon(Icons.map_outlined)),
    );
  }
}

class DayWidget extends StatefulWidget {
  const DayWidget({super.key, required this.day});

  final Day day;
  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool expanded = false;
  final GlobalKey<_DayWidgetState> dayWidgetKey = GlobalKey<_DayWidgetState>();
  @override
  Widget build(BuildContext context) {
    var trip = Provider.of<Trip>(context, listen: false);
    if (!expanded) {
      return buildUnexpandedDayWidget();
    } else {
      return buildExpandedDayWidget(trip.id, widget.day);
    }
  }

  Widget buildUnexpandedDayWidget() {
    var trip = Provider.of<Trip>(context, listen: false);
    return Card(
        elevation: 10,
        color: Colors.amber[50],
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('d MMMM yyyy').format(widget.day.dayDate),
                    style: TextStyle(fontSize: 25),
                  ),
                  Row(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MultiProvider(
                                      child: DayPage(day: widget.day),
                                      providers: [
                                        Provider.value(value: widget.day),
                                        Provider.value(value: trip)
                                      ],
                                    )));
                      },
                      icon: Icon(Icons.info),
                      tooltip: 'View day details',
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            expanded = !expanded;
                          });
                        },
                        icon: Icon(Icons.arrow_circle_down))
                  ])
                ])));
  }

  Widget buildExpandedDayWidget(String tripId, Day day) {
    var trip = Provider.of<Trip>(context, listen: false);
    return Card(
        elevation: 10,
        color: Colors.amber[50],
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    DateFormat('d MMMM yyyy').format(widget.day.dayDate),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Row(children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    child: DayPage(day: widget.day),
                                    providers: [
                                        Provider.value(value: widget.day),
                                        Provider.value(value: trip)
                                    ],
                                  )));
                    },
                    icon: Icon(Icons.info),
                    tooltip: 'View day details',
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                      icon: Icon(Icons.arrow_circle_up))
                ]),
              ]),
              Provider.value(value:day, child: AttractionsListUnderDay())
            ],
          ),
        ));
  }
}

class AttractionsListUnderDay extends StatelessWidget {
  AttractionsListUnderDay({super.key});

  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen:false);
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
          stream: firestoreService.getAttractionsStream(
              trip.id, day.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final attractions = snapshot.data!.docs;
              return ListView.separated(
                shrinkWrap: true,
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
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () async {
              final a = await Navigator.push<Attraction>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttractionCreationForm(),
                  ));
              if (a != null) {
                final s = await firestoreService.addAttraction(
                    trip.id, day.id, a);
                a.id = s;
              }
            },
            child: Text("Add atraction")),
      ),
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
          stream: firestoreService.getSleepoversStream(
              trip.id, day.id),
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
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () async {
              final a = await Navigator.push<Sleepover?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SleepoverCreationForm(),
                  ));
              if (a != null) {
                final s = await firestoreService.addSleepover(
                    trip.id, day.id, a);
                  a.id = s;
              }
            },
            child: Text("Add sleepover")),
      ),
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
          stream: firestoreService.getTransportsStream(
              trip.id, day.id),
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
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () async {
              final a = await Navigator.push<Transport>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransportCreationForm(),
                  ));
              if (a != null) {
                String id = await firestoreService.addTransport(
                    trip.id, day.id, a);
                a.id = id;
              }
            },
            child: Text("Add transport")),
      ),
    ]);
  }
}

class AttractionsSmallListViewElement extends StatelessWidget {
  const AttractionsSmallListViewElement(
      {super.key,
      required this.attraction,});
  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen:false);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.pin_drop)),
          Builder(
            builder: (context) {
              if (attraction.start == null &&
                  attraction.end == null) {
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
                                  "start: ${attraction.start!.hour}:${attraction.start!.minute} ")
                              : Text(""),
                          attraction.end != null
                              ? Text(
                                  "end: ${attraction.end!.hour}:${attraction.end!.minute}")
                              : Text(""),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          PopupMenuButton(
              onSelected: (value) async {
                if (value == "delete") {
                  FirestoreService().deleteAttraction(
                      trip.id, day.id, attraction.id);
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttractionCreationForm(
                          toEdit: attraction,
                        ),
                      ));
                  FirestoreService().updateAttraction(
                      trip.id, day.id, attraction, a);
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "delete", child: Center(child: Text("delete"))),
                    PopupMenuItem(
                        value: "edit", child: Center(child: Text("edit")))
                  ])
        ]));
  }
}

class SleepoverSmallListViewElement extends StatelessWidget {
  const SleepoverSmallListViewElement(
      {super.key, required this.sleepover});

  final Sleepover sleepover;


  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen:false);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.all(8.0), child: Icon(Icons.house_rounded)),
          Builder(builder: (context) {
            if (sleepover.checkin == null &&
                sleepover.checkout == null) {
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sleepover.checkin != null
                            ? Text(
                                "start: ${sleepover.checkin!.hour}:${sleepover.checkin!.minute} ")
                            : Text(""),
                        sleepover.checkout != null
                            ? Text(
                                "end: ${sleepover.checkout!.hour}:${sleepover.checkout!.minute}")
                            : Text(""),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
          PopupMenuButton(
              onSelected: (value) async {
                if (value == "delete") {
                  firestoreService.deleteSleepover(
                      trip.id, trip.id, sleepover.id);
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepoverCreationForm(
                          toEdit: sleepover,
                        ),
                      ));
                  FirestoreService().updateSleepover(
                    trip.id, day.id, sleepover, a);
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "delete", child: Center(child: Text("delete"))),
                    PopupMenuItem(
                        value: "edit", child: Center(child: Text("edit")))
                  ])
        ]),
      );
    
  }
}

class TransportSmallListViewElement extends StatelessWidget {
  const TransportSmallListViewElement(
      {super.key,
      required this.transport,});
  final Transport transport;

  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context, listen: false);
    final day = Provider.of<Day>(context, listen:false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.all(8.0), child: Icon(Icons.airplanemode_on)),
        Flexible(
            child:
                Text(transport.source + " - " + transport.dest)),
        PopupMenuButton(
            onSelected: (value) async {
              if (value == "delete") {
                FirestoreService().deleteTransport(
                    trip.id, day.id, transport.id);
              } else {
                final a = await Navigator.push<Transport?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransportCreationForm(
                        toEdit: transport,
                      ),
                    ));
                if (a != null) {
                  FirestoreService().updateTransport(
                      trip.id, day.id, transport, a);
                }
              }
            },
            itemBuilder: (context) => [
                  PopupMenuItem(
                      value: "delete", child: Center(child: Text("delete"))),
                  PopupMenuItem(
                      value: "edit", child: Center(child: Text("edit")))
                ])
      ]),
    );
  }
}
