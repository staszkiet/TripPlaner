import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/activityCreationForms.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:tripplaner/trip.dart';
import 'package:tripplaner/day.dart';
import 'package:tripplaner/directionsRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

//TODO: dodać stacka z dwoma elevated buttonami, metody są przygotowane w daysProvider
class CustomMarker extends Marker {
  Activity? activity;
  CustomMarker(
      {required this.activity,
      required MarkerId markerId,
      required BitmapDescriptor icon,
      required LatLng position,
      required InfoWindow infoWindow,
      Function()? onTap})
      : super(
            markerId: markerId,
            icon: icon,
            position: position,
            infoWindow: infoWindow,
            onTap: onTap);
}

class tripMapView extends StatefulWidget {
  const tripMapView({super.key, required this.t});

  final Trip t;

  @override
  State<tripMapView> createState() => _tripMapViewState();
}

class _tripMapViewState extends State<tripMapView> {
  Set<Polyline> lines = Set();
  bool poliloaded = false;
  bool editMode = false;
  Activity? selected;
  int dayIndex = -1;

  void AddDirections({required LatLng origin, required LatLng dest}) async {
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
    for (Day d in widget.t.daysProvider.items) {
      for (Transport t in d.transportProvider.items) {
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
    Set<CustomMarker> markers = Set();
    int idx = 0;
    for (Day d in widget.t.daysProvider.items) {
      for (Attraction a in d.attractionsProvider.items) {
        if (a.location != null) {
          markers.add(
            CustomMarker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              markerId: MarkerId("${idx++}"),
              position: a.location!,
              infoWindow: InfoWindow(title: "DAY ${d.index}: ${a.name}"),
              activity: a,
              onTap: (){setState((){selected = a; dayIndex = d.index; editMode = true;});}
            ),
          );
        }
      }
      if (d.sleepoverProvider.sleepover != null) {
        Sleepover? s = d.sleepoverProvider.sleepover;
        markers.add(
          CustomMarker(
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            markerId: MarkerId("${idx++}"),
            position: s!.location!,
            infoWindow:
                InfoWindow(title: "DAY ${d.index}: SLEEPOVER IN: ${s.name}"),
            activity: s,
              onTap: (){setState((){selected = s; dayIndex = d.index; editMode = true;});}
          ),
        );
      }
      for (Transport t in d.transportProvider.items) {
        if (t.sourceLocation != null && t.destLocation != null) {
          markers.add(
            CustomMarker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              markerId: MarkerId("${idx++}"),
              position: t.sourceLocation!,
              infoWindow: InfoWindow(
                  title: "DAY ${d.index}: SLEEPOVER IN: ${t.source}"),
              activity: t,
                onTap: (){setState((){selected = t; dayIndex = d.index; editMode = true;});}
            ),
          );
          markers.add(
            CustomMarker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              markerId: MarkerId("${idx++}"),
              position: t.destLocation!,
              infoWindow:
                  InfoWindow(title: "DAY ${d.index}: SLEEPOVER IN: ${t.dest}"),
              activity: t,
              onTap: (){setState((){selected = t; dayIndex = d.index; editMode = true;});}
            ),
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
                onPressed: () {widget.t.daysProvider.removeActivity(dayIndex, selected); setState(() {markers = Set();
                  lines = Set(); poliloaded = false; 
                });},
                child: Text("delete"),
              ),
              ElevatedButton(onPressed: () async{
                switch(selected)
                {
                  case Attraction():
                  {
                    final a = await Navigator.push<Attraction>(context, MaterialPageRoute(builder: (context) => AttractionCreationForm(toEdit:selected as Attraction)));
                    widget.t.daysProvider.editActivity(dayIndex, selected, a);
                    break;
                  }
                  case Sleepover():
                  {
                    final a = await Navigator.push<Sleepover>(context, MaterialPageRoute(builder: (context) => SleepoverCreationForm(toEdit:selected as Sleepover)));
                    widget.t.daysProvider.editActivity(dayIndex, selected, a);
                    break;
                  }
                  case Transport():
                  {
                    final a = await Navigator.push<Transport>(context, MaterialPageRoute(builder: (context) => TransportCreationForm(toEdit:selected as Transport)));
                    widget.t.daysProvider.editActivity(dayIndex, selected, a);
                    break;
                  }
                  default:
                  {
                    break;
                  }
                }
                setState(() {markers = Set();
                  lines = Set(); poliloaded = false; 
                });
              }, child: Text("edit"))
            ])
        ]));
  }
}
