import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tripplaner/activity_creation_forms.dart';
import 'package:tripplaner/day_activities.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day.dart';
import 'package:tripplaner/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripplaner/firestore.dart';

class CustomMarker extends Marker {
  final Activity? activity;
  const CustomMarker(
      {required this.activity,
      required super.markerId,
      required super.icon,
      required super.position,
      required super.infoWindow,
      Function()? super.onTap});
}

class TripMapView extends StatefulWidget {
  const TripMapView({super.key, required this.t});

  final Trip t;

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  Set<Polyline> lines = {};
  bool poliloaded = false;
  bool editMode = false;
  Activity? selected;
  String dayIndex = "";

  void addDirections({required LatLng origin, required LatLng dest}) async {
    final directions = await DirectionsRepository()
        .getDirections(origin: origin, destination: dest);
    List<LatLng> list = List<LatLng>.empty(growable: true);
    for (PointLatLng p in directions.polylinePoints) {
      list.add(LatLng(p.latitude, p.longitude));
    }
    setState(() => lines.add(Polyline(
        polylineId: PolylineId("${lines.length}"),
        color: Colors.red,
        width: 5,
        points: list)));
  }

  void _initalizePolylines() async {
    Set<Polyline> newLines = {};
    for (Day d in widget.t.days) {
      for (Transport t in d.transport) {
        if (t.sourceLocation != null && t.destLocation != null) {
          final directions = await DirectionsRepository().getDirections(
              origin: t.sourceLocation!, destination: t.destLocation!);
          List<LatLng> points = directions.polylinePoints
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();
          newLines.add(Polyline(
            polylineId: PolylineId("${newLines.length}"),
            color: Colors.red,
            width: 5,
            points: points,
          ));
        }
      }
    }
    setState(() {
      lines = newLines;
      poliloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<CustomMarker> markers = {};
    int idx = 0;
    for (Day d in widget.t.days) {
      for (Attraction a in d.attractions) {
        if (a.location != null) {
          markers.add(
            CustomMarker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
                markerId: MarkerId("${idx++}"),
                position: a.location!,
                infoWindow: InfoWindow(
                    title: "DAY ${d.index + 1}: Attraction: ${a.name}"),
                activity: a,
                onTap: () {
                  setState(() {
                    selected = a;
                    dayIndex = d.id;
                    editMode = true;
                  });
                }),
          );
        }
      }
      for (Sleepover s in d.sleepovers) {
        if (s.location != null) {
          markers.add(
            CustomMarker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
                markerId: MarkerId("${idx++}"),
                position: s.location!,
                infoWindow: InfoWindow(
                    title: "DAY ${d.index + 1}: Sleepover: ${s.name}"),
                activity: s,
                onTap: () {
                  setState(() {
                    selected = s;
                    dayIndex = d.id;
                    editMode = true;
                  });
                }),
          );
        }
      }
      for (Transport t in d.transport) {
        if (t.sourceLocation != null && t.destLocation != null) {
          markers.add(
            CustomMarker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                markerId: MarkerId("${idx++}"),
                position: t.sourceLocation!,
                infoWindow: InfoWindow(
                    title: "DAY ${d.index + 1}: Source: ${t.source}"),
                activity: t,
                onTap: () {
                  setState(() {
                    selected = t;
                    dayIndex = d.id;
                    editMode = true;
                  });
                }),
          );
          markers.add(
            CustomMarker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                markerId: MarkerId("${idx++}"),
                position: t.destLocation!,
                infoWindow: InfoWindow(
                    title: "DAY ${d.index + 1}: Destination: ${t.dest}"),
                activity: t,
                onTap: () {
                  setState(() {
                    selected = t;
                    dayIndex = d.id;
                    editMode = true;
                  });
                }),
          );
          if (!poliloaded) {
            _initalizePolylines();
          }
        }
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Trip Overview"),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 12,
            ),
            onTap: (position) {
              if (editMode) {
                setState(() {
                  editMode = !editMode;
                });
              }
            },
            markers: markers,
            polylines: lines,
          ),
          if (editMode)
            Row(children: [
              ElevatedButton(
                onPressed: () async {
                  var days = widget.t.days;
                  switch (selected) {
                    case Attraction():
                      {
                        FirestoreService().deleteAttraction(
                            widget.t.id, dayIndex, (selected as Attraction).id);
                        days = await FirestoreService()
                            .fetchDaysWithAttractions(widget.t.id);
                      }
                    case Transport():
                      {
                        FirestoreService().deleteTransport(
                            widget.t.id, dayIndex, (selected as Transport).id);
                        days = await FirestoreService()
                            .fetchDaysWithAttractions(widget.t.id);
                      }
                    case Sleepover():
                      {
                        FirestoreService().deleteSleepover(
                            widget.t.id, dayIndex, (selected as Sleepover).id);
                        days = await FirestoreService()
                            .fetchDaysWithAttractions(widget.t.id);
                      }
                    default:
                      {
                        break;
                      }
                  }
                  setState(() {
                    markers = {};
                    lines = {};
                    poliloaded = false;
                    widget.t.days = days;
                  });
                },
                child: Text("delete"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var days = widget.t.days;
                    switch (selected) {
                      case Attraction():
                        {
                          final a = await Navigator.push<Attraction>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttractionCreationForm(
                                      toEdit: selected as Attraction)));
                          if (a != null) {
                            FirestoreService().updateAttraction(widget.t.id,
                                dayIndex, selected as Attraction, a);
                            days = await FirestoreService()
                                .fetchDaysWithAttractions(widget.t.id);
                          }
                          break;
                        }
                      case Sleepover():
                        {
                          final a = await Navigator.push<Sleepover>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SleepoverCreationForm(
                                      toEdit: selected as Sleepover)));
                          if (a != null) {
                            FirestoreService().updateSleepover(widget.t.id,
                                dayIndex, selected as Sleepover, a);
                            days = await FirestoreService()
                                .fetchDaysWithAttractions(widget.t.id);
                          }
                          break;
                        }
                      case Transport():
                        {
                          final a = await Navigator.push<Transport>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransportCreationForm(
                                      toEdit: selected as Transport)));
                          if (a != null) {
                            FirestoreService().updateTransport(widget.t.id,
                                dayIndex, selected as Transport, a);
                            days = await FirestoreService()
                                .fetchDaysWithAttractions(widget.t.id);
                          }
                          break;
                        }
                      default:
                        {
                          break;
                        }
                    }
                    setState(() {
                      markers = {};
                      lines = {};
                      poliloaded = false;
                      widget.t.days = days;
                    });
                  },
                  child: Text("edit"))
            ])
        ]));
  }
}
