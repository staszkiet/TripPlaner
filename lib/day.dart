import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/tripPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tripplaner/firestore.dart';
import 'package:tripplaner/trip.dart';
import "package:intl/intl.dart";

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
            title: Text(
              DateFormat('d MMMM yyyy').format(day.dayDate),
            )),
        body: Container(
            color: Colors.blue[50],
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                Text("Attractions",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  StreamBuilder(
                      stream: FirestoreService()
                          .getAttractionsStream(trip.id, day.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final attractions = snapshot.data!.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: attractions.length,
                            itemBuilder: (context, index) {
                              return AttractionsWidget(
                                attraction: Attraction.fromJson(
                                    attractions[index].data()
                                        as Map<String, dynamic>,
                                    attractions[index].id),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return Text("click plus to add attractions");
                        }
                      }),
                      AttractionAddButton(),
                     Divider(color: Colors.black),
                  Text("Sleepovers",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  StreamBuilder(
                      stream: FirestoreService()
                          .getSleepoversStream(trip.id, day.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          final sleepovers = snapshot.data!.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: sleepovers.length,
                            itemBuilder: (context, index) {
                              return SleepoverWidget(
                                sleepover: Sleepover.fromJson(
                                    sleepovers[index].data()
                                        as Map<String, dynamic>,
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
                      SleepoverAddButton(),
                    Divider(color: Colors.black),
                  Text("Transports",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  StreamBuilder(
                      stream: FirestoreService()
                          .getTransportsStream(trip.id, day.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty ) {
                          final transports = snapshot.data!.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transports.length,
                            itemBuilder: (context, index) {
                              return TransportWidget(
                                transport: Transport.fromJson(
                                    transports[index].data()
                                        as Map<String, dynamic>,
                                    transports[index].id),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return Text("no transports");
                        }
                      }),
                      TransportAddButton(),
                  Divider(color: Colors.black),
                    Text("Photos",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      StreamBuilder(
                          stream: FirestoreService()
                              .getPhotosStream(trip.id, day.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Text("no photos");
                            } else {
                              final photos = snapshot.data!.docs;
                              return SingleChildScrollView(
                                  child: Wrap(
                                      children: photos.map((e) {
                                return PhotoListViewElement(
                                  photo: UploadedPhoto.fromJson(
                                      e.data() as Map<String, dynamic>, e.id),
                                );
                              }).toList()));
                            }
                          }),
                  IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      addPhoto(trip.id, day.id);
                    },
                  ),
                ],
              ),
            )));
  }

  void addPhoto(String tripId, String dayId) async {
    FilePickerResult? res =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (res != null) {
      //final url = await FirestoreService().addFileToStorage(tripId, dayId, res);

      FirestoreService().addPhoto(
          tripId, dayId, UploadedPhoto(urlDownload: res.files.first.path!));
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
          builder: (context) =>
              Dialog(child: Image.file(File(photo.urlDownload))),
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

class AttractionsWidget extends StatelessWidget {
  const AttractionsWidget({super.key, required this.attraction});

  final Attraction attraction;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue[200],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.pin_drop)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Column(children: [Text(attraction.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),), 
            Text("start: ${attraction.start == null ? "??" : attraction.start!.hour.toString() + ":" + attraction.start!.minute.toString()}"),
            Text("end: ${attraction.end == null ? "??" : attraction.end!.hour.toString() + ":" + attraction.end!.minute.toString()}"),
            Text("cost: ${ attraction.price.toString() + attraction.currency}")
            ],),),
             ActivityPopupMenu(activity: attraction)
          ],
       )
    );
  }
}

class SleepoverWidget extends StatelessWidget {
  const SleepoverWidget({super.key, required this.sleepover});
  final Sleepover sleepover;
  @override
  Widget build(BuildContext context) {
     return Card(
        color: Colors.green[200],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.house)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10), child:Column(children: [Text(sleepover.name, style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
            Text("check-in: ${sleepover.checkin == null ? "??" : sleepover.checkin!.hour.toString() + ":" + sleepover.checkin!.minute.toString()}"),
            Text("checkout: ${sleepover.checkout == null ? "??" : sleepover.checkout!.hour.toString() + ":" + sleepover.checkout!.minute.toString()}"),
            Text("cost: ${ sleepover.price.toString() + sleepover.currency}")
            ],),),
             ActivityPopupMenu(activity: sleepover)
          ],
       )
    );
  }
}

class TransportWidget extends StatelessWidget {
  const TransportWidget({super.key, required this.transport});
  final Transport transport;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.orange[200],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.black, width: 2.0),
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.route)),
           Padding(padding:EdgeInsets.symmetric(vertical: 10)  ,child: Column(children: [
            Text("source: " + transport.source),
            Text("dest: " + transport.dest),
            ],),),
             ActivityPopupMenu(activity: transport)
          ],
       )
    );
  }
}