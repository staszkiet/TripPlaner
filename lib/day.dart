import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/tripPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tripplaner/firestore.dart';
import 'package:tripplaner/trip.dart';

class DayPage extends StatelessWidget {
  const DayPage({super.key, required this.day});
  final Day day;
  @override
  Widget build(BuildContext context) {
    final trip = Provider.of<Trip>(context);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("DAY ${day.index + 1}")),
        body: Container(
            color: Colors.amber[50],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AttractionsListUnderDay(),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      height: 300,
                      child: StreamBuilder(
                          stream: FirestoreService()
                              .getPhotosStream(trip.id, day.id),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData)
                            {
                              return Text("no photos");
                            }
                            else
                            {
                              final photos = snapshot.data!.docs;
                                  return SingleChildScrollView(
                                child: Wrap(
                                    children:  photos.map((e) {
                              return PhotoListViewElement(
                                photo: UploadedPhoto.fromJson(e.data() as Map<String, dynamic>, e.id),
                              );
                            }).toList()));
                            }
                            
                          })),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      AddPhoto(trip.id, day.id);
                    },
                  ),
                ],
              ),
            )));
  }

  void AddPhoto(String tripId, String dayId) async {
    FilePickerResult? res =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null) {
      //final url = await FirestoreService().addFileToStorage(tripId, dayId, res);

      FirestoreService().addPhoto(tripId, dayId, UploadedPhoto(urlDownload: res.files.first.path!));
    }
  }
}

class PhotoListViewElement extends StatelessWidget {
  PhotoListViewElement({super.key, required this.photo});
  final UploadedPhoto photo;

  Offset? _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
      final trip = Provider.of<Trip>(context);
      final day = Provider.of<Day>(context);
    return GestureDetector(
      onTap: () {
        // Handle image tap
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Image.file(File(photo.urlDownload))
          ),
        );
      },
      onTapDown: _storePosition,
      onLongPress: () async {
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
             FirestoreService().deletePhoto(trip.id, day.id, photo.id);
             print(photo.id);
           }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(photo.urlDownload),
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
  List<Attraction> attractions = [];
  List<Transport> transport = [];
  List<Sleepover> sleepovers = [];
  List<String> images = [];
  String id = "";

  Day(this.dayDate, this.index, {this.id = ""});

  factory Day.fromJson(Map<String, dynamic> json, String id) {
    Day d = Day((json['dayDate'] as Timestamp).toDate(), json['index'] as int,
        id: id);
    return d;
  }
  toJson() {
    return {
      "dayDate": dayDate,
      "index": index,
    };
  }
}

class UploadedPhoto {
  final String urlDownload;
  String id = "";

  UploadedPhoto({required this.urlDownload, this.id = ""});

  factory UploadedPhoto.fromJson(Map<String, dynamic> json, String id) {
    UploadedPhoto photo = UploadedPhoto(urlDownload: json['url'], id: id);
    return photo;
  }

  toJson() {
    return {
      "url": urlDownload,
    };
  }
}
