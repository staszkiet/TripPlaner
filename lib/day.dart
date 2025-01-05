import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/tripPage.dart';
import 'package:file_picker/file_picker.dart';

class DayPage extends StatelessWidget {
  const DayPage({super.key, required this.day});
  final Day day;
  @override
  Widget build(BuildContext context) {
    final images = context.watch<ImagesProvider>();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous page
              },
            ),
            title: Text("DAY ${day.index + 1}")),
        body: Container(color: Colors.amber[50], child: SingleChildScrollView(
          child: Column(
            children: [
              AttractionsListUnderDay(tripID: "", dayIndex: day.index,),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                      child: Wrap(
                          children: images.items.map((e) {
                    return PhotoListViewElement(path: e, images: images,);
                  }).toList()))),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () {
                  AddPhoto(images);
                },
              ),
            ],
          ),
        )));
  }

  void AddPhoto(ImagesProvider images) async {
    FilePickerResult? res =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null) {
      String? path = res.files.first.path;
      if (path != null) {
        images.addItem(path);
      }
    }
  }
}

class PhotoListViewElement extends StatelessWidget {
  PhotoListViewElement({super.key, required this.path, required this.images});
  final String path;
  final ImagesProvider images;

  Offset? _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle image tap
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Image.file(File(path)),
          ),
        );
      },
      onTapDown: _storePosition,
      onLongPress: ()async {
        if (_tapPosition != null) {
          final result = await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                _tapPosition!.dx,
                _tapPosition!.dy,
                MediaQuery.of(context).size.width - _tapPosition!.dx,
                MediaQuery.of(context).size.height - _tapPosition!.dy,
              ),
              items: [PopupMenuItem(value: "delete", child: Text("delete"))]);
          if (result == "delete") {
            images.deleteItem(path);
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
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
  final ImagesProvider imagesProvider = ImagesProvider();

  Day(this.dayDate, this.index);


  factory Day.fromJson(Map<String, dynamic> json) {
     Day d =  Day(
      (json['dayDate'] as Timestamp).toDate(),
      json['index'] as int);
      d.attractionsProvider.items = (json['attractions'] as List).map((item) => Attraction.fromJson(item)).toList();
      d.sleepoverProvider.sleepover = json['sleepover'] == null ? null : Sleepover.fromJson(json['sleepover']);
      d.transportProvider.items = (json['transport'] as List).map((item) => Transport.fromJson(item)).toList();
      d.imagesProvider.items = (json['images'] as List).map((item) => item.toString()).toList();
    return d;
  }
  toJson()
  {
    return {
      "dayDate" : dayDate,
      "index": index,
      "attractions": attractionsProvider.items.map((attraction) => attraction.toJson()).toList(),
      "sleepover": sleepoverProvider.sleepover?.toJson(),
      "transport": transportProvider.items.map((t) => t.toJson()).toList(),
      "images": imagesProvider.items
    };
  }


}

class DaysProvider with ChangeNotifier {
  List<Day> items = [];


  void addItem(Day t) {
    items.add(t);
  }

  void removeActivity(int dayIndex, Activity? a)
  {
    Day d = items[dayIndex];
    switch(a)
    {
      case Attraction():
      {
        d.attractionsProvider.deleteItem(a);
        break;
      }
      case Sleepover():
      {
        if(d.sleepoverProvider.sleepover == a)
        {
           d.sleepoverProvider.deleteItem();
        }
        break;
      }
      case Transport():
      {
        d.transportProvider.deleteItem(a);
        break;
      }
      case null:
      {
        print("null");
        break;
      }
    }
    notifyListeners();
  }

  void editActivity(int dayIndex, Activity? out, Activity? into)
  {
    Day d = items[dayIndex];
    switch((out, into))
    {
      case (Attraction(), Attraction()):
      {
        d.attractionsProvider.replaceItem(into as Attraction, out as Attraction);
        break;
      }
      case(Sleepover(), Sleepover()):
      {
        if(out == d.sleepoverProvider.sleepover)
        {
          d.sleepoverProvider.changeSleepover(into as Sleepover);
        }
        break;
      }
      case(Transport(), Transport()):
      {
        d.transportProvider.replaceItem(into as Transport, out as Transport);
        break;
      }
      default:
      {
        break;
      }
    }
    notifyListeners();
  }
}

class ImagesProvider with ChangeNotifier {
  List<String> items = [];

  void addItem(String t) {
    items.add(t);
    notifyListeners();
  }

  void deleteItem(String t) {
    if(!items.remove(t))
    {
      print("ni mo");
    }
    notifyListeners();
  }
}
