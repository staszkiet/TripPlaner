import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/dayActivities.dart';

class AttractionCreationForm extends StatefulWidget {
  const AttractionCreationForm({super.key});

  @override
  State<AttractionCreationForm> createState() => _AttractionCreationFormState();
}

class _AttractionCreationFormState extends State<AttractionCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  TimeOfDay? start;
  TimeOfDay? end;

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

  @override
  Widget build(BuildContext context) {
    final attractions = context.watch<AttractionProvider>();
    _startController.text =
        start == null ? "Select start " : "${start!.hour}:${start!.minute}";
    _endController.text =
        end == null ? "Select end date" : "${end!.hour}:${end!.minute}";
    return Material(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
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
                      attractions.addItem(Attraction(_nameController.text,
                          start: start, end: end));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          )),
    );
  }
}

class SleepoverCreationForm extends StatefulWidget {
  const SleepoverCreationForm({super.key});

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
    final sleepover = context.watch<SleepoverProvider>();
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
              TextFormField(
                controller: _nameController,
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
                      sleepover.changeSleepover(Sleepover(_nameController.text,
                          checkin: checkin, checkout: checkout));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          )),
    );
  }
}


class TransportCreationForm extends StatefulWidget {
  const TransportCreationForm({super.key});

  @override
  State<TransportCreationForm> createState() => _TransportCreationFormState();
}

class _TransportCreationFormState extends State<TransportCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final transports = context.watch<TransportProvider>();
    return Material(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _sourceController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
                TextFormField(
                controller: _destController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      transports.addItem(Transport(source:_sourceController.text, dest:_destController.text));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          )),
    );
  }
}