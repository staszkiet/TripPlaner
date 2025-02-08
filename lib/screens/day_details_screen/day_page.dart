import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tripplaner/services/firestore/firestore.dart';
import 'package:tripplaner/models/trip.dart';
import "package:intl/intl.dart";
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/models/uploaded_photo.dart';
import 'photo_element.dart';
import 'activity_elements.dart';
import 'package:tripplaner/components/activity_add_buttons.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

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
                  SizedBox(
                    height: 20,
                  ),
                  Text("Attractions",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  StreamBuilder(
                      stream: FirestoreService()
                          .getAttractionsStream(trip.id, day.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
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
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
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
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
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
                      stream:
                          FirestoreService().getPhotosStream(trip.id, day.id),
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
