import 'package:flutter/material.dart';
import 'package:tripplaner/trip.dart';
import 'package:provider/provider.dart';

class TripCreationForm extends StatefulWidget {
  const TripCreationForm({super.key});

  @override
  State<TripCreationForm> createState() => _TripCreationFormState();
}

class _TripCreationFormState extends State<TripCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  // Function to show date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripProvider>();
    _startDateController.text =
        startDate == null ? "Select start date" : startDate.toString();
    _endDateController.text =
        endDate == null ? "Select end date" : endDate.toString();
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
                controller: _startDateController,
                onTap: () {
                  _selectDate(context, true);
                },
                validator: (value) {
                  if (startDate == null) {
                    return "Pick a start date";
                  }
                  if (endDate != null && endDate!.isBefore(startDate!)) {
                    return "start date must be before end date";
                  }
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _endDateController,
                onTap: () {
                  _selectDate(context, false);
                },
                validator: (value) {
                  if (endDate == null) {
                    return "Pick a start date";
                  }
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      trips.addItem(
                          Trip(_nameController.text, startDate!, endDate!));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          )),
    );
  }
}
