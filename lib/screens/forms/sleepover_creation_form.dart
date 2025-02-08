import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:tripplaner/screens/forms/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

class SleepoverCreationForm extends StatefulWidget {
  const SleepoverCreationForm({super.key, this.toEdit});

  final Sleepover? toEdit;
  @override
  State<SleepoverCreationForm> createState() => _SleepoverCreationFormState();
}

class _SleepoverCreationFormState extends State<SleepoverCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  TimeOfDay? checkin;
  TimeOfDay? checkout;
  LatLng? location;
  bool initialized = false;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          checkin = picked;
        } else {
          checkout = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.toEdit != null && !initialized) {
      checkin = widget.toEdit!.checkin;
      checkout = widget.toEdit!.checkout;
      location = widget.toEdit!.location;
      _nameController.text = widget.toEdit!.name;
      initialized = false;
    }

    _startController.text = checkin == null
        ? "Select checkin hour"
        : timeFormatter
            .format(DateTime(0, 1, 1, checkin!.hour, checkin!.minute));
    _endController.text = checkout == null
        ? "Select checkout hour"
        : timeFormatter
            .format(DateTime(0, 1, 1, checkout!.hour, checkout!.minute));
    return Scaffold(
        appBar: AppBar(
          title: widget.toEdit == null
              ? Text("Add sleepover")
              : Text("Edit sleepover"),
        ),
        body: Material(
            child: Row(children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            flex: 3,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Sleepover's name",
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
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "check-in hour",
                      hintText: "Tap to select",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _selectTime(context, true);
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ),
                    controller: _startController,
                    onTap: () {
                      _selectTime(context, true);
                    },
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "check-out hour",
                      hintText: "Tap to select",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _selectTime(context, false);
                        },
                        icon: Icon(Icons.timer),
                      ),
                    ),
                    controller: _endController,
                    onTap: () {
                      _selectTime(context, false);
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        openLocationPicker(context);
                      },
                      child: Text("pick location")),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final toAdd = Sleepover(_nameController.text,
                              checkin: checkin,
                              checkout: checkout,
                              location: location);
                          Navigator.pop(context, toAdd);
                        }
                      },
                      child:
                          widget.toEdit == null ? Text("Add") : Text("Save")),
                ],
              )),
            ),
          ),
          Flexible(flex: 1, child: Container())
        ])));
  }

  void openLocationPicker(BuildContext context) async {
    final pom = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );

    if (pom != null) {
      location = LatLng(pom[0], pom[1]);
    }
  }
}
