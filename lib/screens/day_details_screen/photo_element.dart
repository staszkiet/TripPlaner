import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tripplaner/models/uploaded_photo.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/models/trip.dart';
import 'package:tripplaner/models/day.dart';
import 'package:tripplaner/services/firestore/firestore.dart';

class PhotoListViewElement extends StatefulWidget {
  const PhotoListViewElement({super.key, required this.photo});
  final UploadedPhoto photo;

  @override
  State<PhotoListViewElement> createState() => _PhotoListViewElementState();
}

class _PhotoListViewElementState extends State<PhotoListViewElement> {
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
        showDialog(
          context: context,
          builder: (context) =>
              Dialog(child: Image.file(File(widget.photo.urlDownload))),
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
            FirestoreService().deletePhoto(trip.id, day.id, widget.photo.id);
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(widget.photo.urlDownload),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
