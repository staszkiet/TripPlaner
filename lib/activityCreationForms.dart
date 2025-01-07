import 'package:flutter/material.dart';
import 'package:tripplaner/dayActivities.dart';
import 'package:tripplaner/locationPicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttractionCreationForm extends StatefulWidget {
  AttractionCreationForm({super.key, this.toEdit});

  final Attraction? toEdit;

  @override
  State<AttractionCreationForm> createState() => _AttractionCreationFormState();
}

class _AttractionCreationFormState extends State<AttractionCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();

  TimeOfDay? start;
  TimeOfDay? end;
  LatLng? location;
  bool initalized = false;

  // Function to show date picker
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          start = picked;
        } else {
          end = picked;
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (widget.toEdit != null && !initalized) {
      start = widget.toEdit!.start;
      end = widget.toEdit!.end;
      location = widget.toEdit!.location;
      _nameController.text = widget.toEdit!.name;
      initalized = true;
    }
    _startController.text =
        start == null ? "Select start " : "${start!.hour}:${start!.minute}";
    _endController.text =
        end == null ? "Select end date" : "${end!.hour}:${end!.minute}";
    return Material(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Attraction's name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _startController,
                onTap: () {
                  _selectTime(context, true);
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _endController,
                onTap: () {
                  _selectTime(context, false);
                },
              ),
              Row(children: [Text("amount:"),
              SizedBox(width: 100, child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                 validator: (value) => double.tryParse(_amountController.text) == null ? "invalid number" : null,
              ),)]),
              Row(children: [Text("currency:"),
               SizedBox(width: 100, child: TextFormField(
                controller: _currencyController,
      
              ),)
              ]),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final toAdd = Attraction(_nameController.text,
                          start: start, end: end, location: location, currency: _currencyController.text, price: double.parse(_amountController.text));
                      Navigator.pop(context, toAdd);
                    }
                  },
                  child: const Text("Add")),
              ElevatedButton(
                  onPressed: () {
                    openLocationPicker(context);
                  },
                  child: Text("pick location"))
            ],
          )),
    );
  }
}

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

  // Function to show date picker
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
    if(widget.toEdit != null && !initialized)
    {
      checkin = widget.toEdit!.checkin;
      checkout = widget.toEdit!.checkout;
      location = widget.toEdit!.location;
      _nameController.text = widget.toEdit!.name;
      initialized = false;
    }
    _startController.text = checkin == null
        ? "Select checkin hour "
        : "${checkin!.hour}:${checkin!.minute}";
    _endController.text = checkout == null
        ? "Select checkout hour"
        : "${checkout!.hour}:${checkout!.minute}";
    return Material(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Sleepover Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _startController,
                onTap: () {
                  _selectTime(context, true);
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _endController,
                onTap: () {
                  _selectTime(context, false);
                },
              ),
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
                  child: const Text("Add")),
              ElevatedButton(
                  onPressed: () {
                    openLocationPicker(context);
                  },
                  child: Text("pick location"))
            ],
          )),
    );
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
    if(widget.toEdit!=null && !initialized)
    {
      _sourceController.text = widget.toEdit!.source;
      _destController.text = widget.toEdit!.dest;
      source = widget.toEdit!.sourceLocation;
      dest = widget.toEdit!.destLocation;
      initialized = true;
    }
    return Material(
      child: 
      Row(children: [
        Flexible(flex:1, child:Container()),
      Flexible(
        flex: 3,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _sourceController,
                decoration: InputDecoration(hintText: "Source name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destController,
                decoration: InputDecoration(hintText: "Destination name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
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
                  child: const Text("Add"))
            ],
          )),),
          Flexible(child: Container())
          ])
    );
  }

  void openLocationPicker(BuildContext context, bool if_source) async {
    final pom = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationPicker()),
    );

    if (pom != null) {
      if (if_source) {
        source = LatLng(pom[0], pom[1]);
      } else {
        dest = LatLng(pom[0], pom[1]);
      }
    }
  }
}
