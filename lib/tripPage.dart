import 'package:flutter/material.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/dayActivities.dart';

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
        body: ListView.builder(
            itemCount: trip.days.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: trip.days[index].attractionsProvider,
                child: DayWidget(day: trip.days[index]),
              );
            }));
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

  void toggle() {
    expanded = !expanded;
  }

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
          IconButton(icon: Icon(Icons.fire_truck), onPressed: (){attractions.addItem(Attraction("dodane w tripie"));},),
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
      child: Column(children: [
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
          IconButton(icon: Icon(Icons.fire_truck), onPressed: (){attractions.addItem(Attraction("dodane w tripie"));},),
          IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon: Icon(Icons.arrow_circle_up))
        ]),
        ListView.builder(
            shrinkWrap: true,
            itemCount: attractions.items.length,
            itemBuilder: (context, index) {
              return Text(attractions.items[index].name);
            })
      ]),
    );
  }
}
