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
                              child: ToDoListPage(),
                            )));
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: ListView.separated(
        itemCount: trip.daysProvider.items.length,
        itemBuilder: (context, index) => MultiProvider(
          child: DayWidget(day: trip.daysProvider.items[index], tripID: trip.id,),
          providers: [
            ChangeNotifierProvider.value(
              value: trip.daysProvider.items[index].attractionsProvider,
            ),
            ChangeNotifierProvider.value(
              value: trip.daysProvider.items[index].sleepoverProvider,
            ),
            ChangeNotifierProvider.value(
              value: trip.daysProvider.items[index].transportProvider,
            ),
          ],
        ),
        separatorBuilder: (context, index) => SizedBox(height: 20),
      ),
      //ListView.builder(itemBuilder: (context, index) {return DayWidget(day: trip.daysProvider.items[index]);}),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                        value: trip.daysProvider,
                        child: tripMapView(t: trip))));
          },
          child: Icon(Icons.map_outlined)),
    );
  }
}

class DayWidget extends StatefulWidget {
  const DayWidget({super.key, required this.day, required this.tripID});

  final Day day;
  final String tripID;
  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool expanded = false;
  final GlobalKey<_DayWidgetState> dayWidgetKey = GlobalKey<_DayWidgetState>();
  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return buildUnexpandedDayWidget();
    } else {
      return buildExpandedDayWidget(widget.tripID, widget.day.index);
    }
  }

  Widget buildUnexpandedDayWidget() {
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
                                        ChangeNotifierProvider.value(
                                            value:
                                                widget.day.attractionsProvider),
                                        ChangeNotifierProvider.value(
                                          value: widget.day.sleepoverProvider,
                                        ),
                                        ChangeNotifierProvider.value(
                                          value: widget.day.transportProvider,
                                        ),
                                        ChangeNotifierProvider.value(
                                            value: widget.day.imagesProvider)
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

  Widget buildExpandedDayWidget(String tripId, int dayindex) {
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
                                      ChangeNotifierProvider.value(
                                          value:
                                              widget.day.attractionsProvider),
                                      ChangeNotifierProvider.value(
                                        value: widget.day.sleepoverProvider,
                                      ),
                                      ChangeNotifierProvider.value(
                                        value: widget.day.transportProvider,
                                      ),
                                      ChangeNotifierProvider.value(
                                          value: widget.day.imagesProvider)
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
              AttractionsListUnderDay(dayIndex: dayindex, tripID: tripId,)
            ],
          ),
        ));
  }
}

class AttractionsListUnderDay extends StatelessWidget {
  AttractionsListUnderDay({super.key, required this.dayIndex, required this.tripID});
  final int dayIndex;
  final String tripID;
  final firestoreService = FirestoreService(); 
  @override
  Widget build(BuildContext context) {
    final attractions = context.watch<AttractionProvider>();
    final sleepover = context.watch<SleepoverProvider>();
    final transport = context.watch<TransportProvider>();
    return  Column(children: [
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
      ListView.separated(
        shrinkWrap: true,
        itemCount: attractions.items.length,
        itemBuilder: (context, index) {
          return AttractionsSmallListViewElement(
              attraction: attractions.items[index]);
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
      ),
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
                  firestoreService.addAttraction(tripID, dayIndex, a);
                //attractions.addItem(a);
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
      SleepoverSmallListViewElement(sleepover: sleepover.sleepover),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () async {
              final a = await Navigator.push<Sleepover?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SleepoverCreationForm(),
                  ));
              sleepover.changeSleepover(a as Sleepover);
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
      ListView.builder(
          shrinkWrap: true,
          itemCount: transport.items.length,
          itemBuilder: (context, index) {
            return TransportSmallListViewElement(
                transport: transport.items[index]);
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
              transport.addItem(a as Transport);
            },
            child: Text("Add transport")),
      ),
    ]);
  }
}

class AttractionsSmallListViewElement extends StatelessWidget {
  const AttractionsSmallListViewElement({super.key, required this.attraction});
  final Attraction attraction;

  @override
  Widget build(BuildContext context) {
    final attractions = context.watch<AttractionProvider>();
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
                  attractions.deleteItem(attraction);
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttractionCreationForm(
                          toEdit: attraction,
                        ),
                      ));
                  attractions.replaceItem(a, attraction);
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
  const SleepoverSmallListViewElement({super.key, required this.sleepover});
  final Sleepover? sleepover;
  @override
  Widget build(BuildContext context) {
    final sleepoverprovider = context.watch<SleepoverProvider>();
    if (sleepover != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.all(8.0), child: Icon(Icons.house_rounded)),
          Builder(builder: (context) {
            if (sleepover!.checkin == null && sleepover!.checkout == null) {
              return Expanded(
                child: Center(
                  child: Text(
                    sleepover!.name,
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
                      sleepover!.name,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        sleepover!.checkin != null
                            ? Text(
                                "start: ${sleepover!.checkin!.hour}:${sleepover!.checkin!.minute} ")
                            : Text(""),
                        sleepover!.checkout != null
                            ? Text(
                                "end: ${sleepover!.checkout!.hour}:${sleepover!.checkout!.minute}")
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
                  sleepoverprovider.deleteItem();
                } else {
                  final a = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepoverCreationForm(
                          toEdit: sleepover,
                        ),
                      ));
                  sleepoverprovider.changeSleepover(a);
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
    } else {
      return SizedBox(height: 20);
    }
  }
}

class TransportSmallListViewElement extends StatelessWidget {
  const TransportSmallListViewElement({super.key, required this.transport});
  final Transport transport;
  @override
  Widget build(BuildContext context) {
    final transports = context.watch<TransportProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
            padding: EdgeInsets.all(8.0), child: Icon(Icons.airplanemode_on)),
        Flexible(child: Text(transport.source + " - " + transport.dest)),
        PopupMenuButton(
            onSelected: (value) async {
              if (value == "delete") {
                transports.deleteItem(transport);
              } else {
                final a = await Navigator.push<Transport?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransportCreationForm(
                        toEdit: transport,
                      ),
                    ));
                if (a != null) {
                  transports.replaceItem(a, transport);
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
