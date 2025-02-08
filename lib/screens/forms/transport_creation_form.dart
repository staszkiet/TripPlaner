import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:tripplaner/screens/forms/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

class TransportCreationForm extends StatefulWidget {
  const TransportCreationForm({super.key, this.toEdit});

  final Transport? toEdit;
  @override
  State<TransportCreationForm> createState() => _TransportCreationFormState();
}

class _TransportCreationFormState extends State<TransportCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destController = TextEditingController();
  LatLng? source;
  LatLng? dest;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    if (widget.toEdit != null && !initialized) {
      _sourceController.text = widget.toEdit!.source;
      _destController.text = widget.toEdit!.dest;
      source = widget.toEdit!.sourceLocation;
      dest = widget.toEdit!.destLocation;
      initialized = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: widget.toEdit == null
              ? Text("Create Transport")
              : Text("Edit Transport"),
        ),
        body: Material(
            child: Row(children: [
          Flexible(flex: 1, child: Container()),
          Flexible(
            flex: 3,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      labelText: "Source",
                      hintText: "Source's name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _destController,
                    decoration: InputDecoration(
                      labelText: "Destination",
                      hintText: "Destination's name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        openLocationPicker(context, true);
                      },
                      child: Text("pick source")),
                  ElevatedButton(
                      onPressed: () {
                        openLocationPicker(context, false);
                      },
                      child: Text("pick dest")),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final toAdd = Transport(
                              source: _sourceController.text,
                              dest: _destController.text,
                              sourceLocation: source,
                              destLocation: dest);
                          Navigator.pop(context, toAdd);
                        }
                      },
                      child: widget.toEdit == null ? Text("Add") : Text("Save"))
                ],
              )),
            ),
          ),
          Flexible(child: Container())
        ])));
  }

  void openLocationPicker(BuildContext context, bool ifSource) async {
    final pom = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );

    if (pom != null) {
      if (ifSource) {
        source = LatLng(pom[0], pom[1]);
      } else {
        dest = LatLng(pom[0], pom[1]);
      }
    }
  }
}
