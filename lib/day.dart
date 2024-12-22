import 'package:flutter/material.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:provider/provider.dart';

class DayPage extends StatelessWidget {
  const DayPage({super.key, required this.day});
  final Day day;
  @override
  Widget build(BuildContext context) {
    final attractions = context.watch<AttractionProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: attractions.items.length,
            itemBuilder: (context, index) =>
                Text(attractions.items[index].name),
            shrinkWrap: true,
          ),
          Text(day.index.toString()),
          IconButton(
            icon: Icon(Icons.fire_truck),
            onPressed: () {
              attractions.addItem(Attraction("dodane w dniu"));
            },
          ),
        ],
      ),
    );
  }
}

class Day {
  final DateTime dayDate;
  final int index;
  final AttractionProvider attractionsProvider = AttractionProvider();
  final SleepoverProvider sleepoverProvider = SleepoverProvider();
  final TransportProvider transportProvider = TransportProvider();
  Day(this.dayDate, this.index);
}
