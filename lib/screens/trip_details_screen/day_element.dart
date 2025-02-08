import 'package:flutter/material.dart';
import 'package:tripplaner/models/day.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:intl/intl.dart';
import 'package:tripplaner/screens/day_details_screen/day_page.dart';
import 'activities_list.dart';

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
      return buildExpandedDayWidget(trip.id);
    }
  }

  Widget buildUnexpandedDayWidget() {
    var trip = Provider.of<Trip>(context, listen: false);
    return Card(
        elevation: 10,
        color: Colors.blue[200],
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
                                      providers: [
                                        Provider.value(value: widget.day),
                                        Provider.value(value: trip)
                                      ],
                                      child: DayPage(day: widget.day),
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

  Widget buildExpandedDayWidget(String tripId) {
    var trip = Provider.of<Trip>(context, listen: false);
    return Card(
        elevation: 10,
        color: Colors.blue[200],
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
                                    providers: [
                                      Provider.value(value: widget.day),
                                      Provider.value(value: trip)
                                    ],
                                    child: DayPage(day: widget.day),
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
              Provider.value(
                  value: widget.day, child: AttractionsListUnderDay())
            ],
          ),
        ));
  }
}
