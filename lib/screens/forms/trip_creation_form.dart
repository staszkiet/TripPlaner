import 'package:flutter/material.dart';
import 'package:tripplaner/models/trip.dart';

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
    _startDateController.text =
        startDate == null ? "Select start date" : startDate.toString();
    _endDateController.text =
        endDate == null ? "Select end date" : endDate.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Trip"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Material(
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Trip Name",
                        hintText: "Trip Name",
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
                      controller: _startDateController,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        hintText: "Tap to select",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _selectDate(context, true);
                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      onTap: () {
                        _selectDate(context, true);
                      },
                      validator: (value) {
                        if (startDate == null) {
                          return "Pick a start date";
                        }
                        if (endDate != null && endDate!.isBefore(startDate!)) {
                          return "Start date must be before end date";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      readOnly: true,
                      controller: _endDateController,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        hintText: "Tap to select",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _selectDate(context, false);
                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      onTap: () {
                        _selectDate(context, false);
                      },
                      validator: (value) {
                        if (endDate == null) {
                          return "Pick an end date";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                              context,
                              Trip(_nameController.text, startDate!, endDate!),
                            );
                          }
                        },
                        child: const Text("Add"),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
