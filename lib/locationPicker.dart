import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        leading: 
        IconButton(onPressed:() {
            
              if (_selectedLocation != null) {
              Navigator.pop(context, [_selectedLocation!.latitude, _selectedLocation!.longitude]);
            }else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select a location")),
              );
            }
          }, icon: Icon(Icons.done))
        
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (position) {
            setState(() {
              _selectedLocation = LatLng(position.latitude, position.longitude);
            });
        },
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("selected-location"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  position: _selectedLocation!,
                ),
              }
            : {},
      ),
    );
  }
}
