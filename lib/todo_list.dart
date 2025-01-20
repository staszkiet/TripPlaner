import 'package:tripplaner/firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripplaner/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class ToDoElement {
  final String description;
  int notificationID;
  String id = "";
  ToDoElement(
      {required this.description, this.id = "", this.notificationID = -1});

  factory ToDoElement.fromJson(Map<String, dynamic> json, String id) {
    return ToDoElement(
        description: json['description'],
        notificationID: json["notificationID"],
        id: id);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "notificationID": notificationID};
  }
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key, required this.tripId});

  final String tripId;
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final _nameController = TextEditingController();
  final firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TODO List"),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
                stream: firestoreService.getToDoStream(widget.tripId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final elements = snapshot.data!.docs;
                    return ListView.builder(
                      itemBuilder: (context, index) => ToDoElementWidget(
                        element: ToDoElement.fromJson(
                            elements[index].data() as Map<String, dynamic>,
                            elements[index].id),
                        tripId: widget.tripId,
                      ),
                      itemCount: elements.length,
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black)),
                  color: Colors.white),
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Add task",
                      ),
                    )),
                    IconButton(
                        onPressed: () async {
                          ToDoElement t =
                              ToDoElement(description: _nameController.text);
                          String id = await firestoreService.addToDoItem(
                              widget.tripId, t);
                          t.id = id;
                          _nameController.text = "";
                        },
                        icon: Icon(Icons.done))
                  ])))
        ]));
  }
}

class ToDoElementWidget extends StatefulWidget {
  const ToDoElementWidget(
      {super.key, required this.element, required this.tripId});
  final String tripId;
  final ToDoElement element;
  @override
  State<ToDoElementWidget> createState() => _ToDoElementWidgetState();
}

class _ToDoElementWidgetState extends State<ToDoElementWidget> {
  bool notificationOn = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final List<PendingNotificationRequest> notifications =
        await NotificationManager().notifications;
    final notification =
        findNotificationById(notifications, widget.element.notificationID);
    setState(() {
      notificationOn = notification != null;
    });
  }

  PendingNotificationRequest? findNotificationById(
      List<PendingNotificationRequest> notifications, int id) {
    try {
      return notifications.firstWhere((notification) => notification.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[50]),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "task",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              Divider(color: Colors.black),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.create)),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        widget.element.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      FirestoreService()
                          .markItemAsDone(widget.tripId, widget.element);
                    },
                    icon: Icon(Icons.done),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (!notificationOn) {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );

                        if (selectedDate == null) return;
                        TimeOfDay? selectedTime = context.mounted
                            ? await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              )
                            : null;

                        if (selectedTime == null) return;

                        final DateTime scheduledDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        int id = await NotificationManager()
                            .scheduleNotification(scheduledDateTime);
                        widget.element.notificationID = id;
                        FirestoreService().updateToDoElementNotification(
                            widget.tripId, widget.element, id);
                        setState(() {
                          notificationOn = !notificationOn;
                        });
                      } else {
                        NotificationManager()
                            .cancelNotification(widget.element.notificationID);
                        setState(() {
                          notificationOn = !notificationOn;
                        });
                      }
                    },
                    icon: Icon(notificationOn
                        ? Icons.notifications_off
                        : Icons.notification_add),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
