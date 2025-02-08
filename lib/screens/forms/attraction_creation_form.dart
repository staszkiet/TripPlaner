import 'package:flutter/material.dart';
import 'package:tripplaner/models/activities.dart';
import 'package:tripplaner/screens/forms/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

final DateFormat timeFormatter = DateFormat('HH:mm');

class AttractionCreationForm extends StatefulWidget {
  const AttractionCreationForm({super.key, this.toEdit});

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
    _startController.text = start == null
        ? "Select start"
        : timeFormatter.format(DateTime(0, 1, 1, start!.hour, start!.minute));
    _endController.text = end == null
        ? "Select end date"
        : timeFormatter.format(DateTime(0, 1, 1, end!.hour, end!.minute));
    return Scaffold(
        appBar: AppBar(
          title: widget.toEdit == null
              ? Text("Add attraction")
              : Text("Edit attraction"),
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Attraction's name",
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
                      labelText: "Start hour",
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
                      labelText: "End hour",
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
                  Row(children: [
                    Text("amount:"),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) => (!(_amountController.text ==
                                    "") &&
                                double.tryParse(_amountController.text) == null)
                            ? "invalid number"
                            : null,
                      ),
                    )
                  ]),
                  SizedBox(height: 10),
                  Row(children: [
                    Text("currency:"),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _currencyController,
                      ),
                    )
                  ]),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        openLocationPicker(context);
                      },
                      child: Text("pick location")),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final toAdd = Attraction(_nameController.text,
                              start: start,
                              end: end,
                              location: location,
                              currency: _currencyController.text,
                              price: double.tryParse(_amountController.text) ==
                                      null
                                  ? 0
                                  : double.parse(_amountController.text));
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
}
