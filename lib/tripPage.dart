import 'package:flutter/material.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:tripplaner/activityCreationForms.dart';

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
              Navigator.pop(context); // Go back to the previous page
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: List.generate(trip.days.length, (index) {
            return MultiProvider(
              child: DayWidget(day: trip.days[index]),
              providers: [
                ChangeNotifierProvider.value(
                  value: trip.days[index].attractionsProvider,
                ),
                ChangeNotifierProvider.value(
                  value: trip.days[index].sleepoverProvider,
                ),
                ChangeNotifierProvider.value(
                  value: trip.days[index].transportProvider,
                ),
              ],
            );
          }),
        )));
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
    if (!expanded) {
      return buildUnexpandedDayWidget();
    } else {
      return buildExpandedDayWidget();
    }
  }

  Widget buildUnexpandedDayWidget() {
    final attractions = context.watch<AttractionProvider>();
    return Container(
        height: 70,
        color: Colors.amber[50],
        child: Row(children: [
          Text(
            "DAY ${widget.day.index + 1}",
            style: TextStyle(fontSize: 25),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: attractions,
                          child: DayPage(day: widget.day))));
            },
            icon: Icon(Icons.info),
            tooltip: 'View day details',
          ),
          IconButton(
            icon: Icon(Icons.fire_truck),
            onPressed: () {
              attractions.addItem(Attraction("dodane w tripie"));
            },
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(Icons.arrow_circle_down))
        ]));
  }

  Widget buildExpandedDayWidget() {
    final attractions = context.watch<AttractionProvider>();
    return Container(
      color: Colors.amber[50],
      child: Column(
        children: [
          Row(children: [
            Text(
              "DAY ${widget.day.index + 1}",
              style: TextStyle(fontSize: 25),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                            value: attractions,
                            child: DayPage(day: widget.day))));
              },
              icon: Icon(Icons.info),
              tooltip: 'View day details',
            ),
            IconButton(
              icon: Icon(Icons.fire_truck),
              onPressed: () {
                attractions.addItem(Attraction("dodane w tripie"));
              },
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                icon: Icon(Icons.arrow_circle_up))
          ]),
          AttractionsListUnderDay()
        ],
      ),
    );
  }
}

class AttractionsListUnderDay extends StatelessWidget {
  const AttractionsListUnderDay({super.key});

  @override
  Widget build(BuildContext context) {
    final attractions = context.watch<AttractionProvider>();
    final sleepover = context.watch<SleepoverProvider>();
    final transport = context.watch<TransportProvider>();
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text("Attractions:"),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: attractions.items.length,
          itemBuilder: (context, index) {
            return AttractionsSmallListViewElement(
                attraction: attractions.items[index]);
          }),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: attractions,
                            child: AttractionCreationForm(),
                          )));
            },
            child: Text("Add atraction")),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text("Sleepover:"),
      ),
      SleepoverSmallListViewElement(sleepover: sleepover.sleepover),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: sleepover,
                            child: SleepoverCreationForm(),
                          )));
            },
            child: Text("Add sleepover")),
      ),
           Align(
        alignment: Alignment.centerLeft,
        child: Text("Transport:"),
      ),
      ListView.builder(
          shrinkWrap: true,
          itemCount: transport.items.length,
          itemBuilder: (context, index) {
            return TransportSmallListViewElement(
                transport: transport.items[index]);
          }),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                            value: transport,
                            child: TransportCreationForm(),
                          )));
            },
            child: Text("Add transport")),
      ),
    ]);
    
  }
}

// elementy listy atrakcji pojawiającej sie po rozwinięciu widgetu dnia
class AttractionsSmallListViewElement extends StatelessWidget {
  const AttractionsSmallListViewElement({super.key, required this.attraction});
  final Attraction attraction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(Icons.pin_drop),
        Text(attraction.name),
        attraction.start != null
            ? Text(
                "start: ${attraction.start!.hour}:${attraction.start!.minute}")
            : Text("start: unsepcified"),
        attraction.end != null
            ? Text("end: ${attraction.end!.hour}:${attraction.end!.minute}")
            : Text("end: unsepcified"),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ]),
    );
  }
}

class SleepoverSmallListViewElement extends StatelessWidget {
  const SleepoverSmallListViewElement({super.key, required this.sleepover});
  final Sleepover? sleepover;
  @override
  Widget build(BuildContext context) {
    if (sleepover != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(Icons.house_rounded),
          Text(sleepover!.name),
          sleepover!.checkin != null
              ? Text(
                  "check-in: ${sleepover!.checkin!.hour}:${sleepover!.checkin!.minute}")
              : Text("check-in: unsepcified"),
          sleepover!.checkout != null
              ? Text(
                  "check-out: ${sleepover!.checkout!.hour}:${sleepover!.checkout!.minute}")
              : Text("check-out: unsepcified"),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(Icons.airplanemode_on),
          Text(transport.source + "-" + transport.dest),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ]),
      );
  }
}
