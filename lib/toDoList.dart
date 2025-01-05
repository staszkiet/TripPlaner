import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/firestore.dart';

class ToDoElement {
  final String description;
  bool done = false;
  String id = "";
  ToDoElement({required this.description, bool done = false, this.id = ""}) {
    this.done = done;
  }

  factory ToDoElement.fromJson(Map<String, dynamic> json, String id) {
    return ToDoElement(
      description: json['description'],
      done: json['done'] ?? false,
      id:id
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "done": done,
    };
  }
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key, required this.tripId});

  final String tripId;
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class ToDoListProvider with ChangeNotifier {
  List<ToDoElement> doneElements = [];
  List<ToDoElement> notDoneElements = [];

  void addItem(ToDoElement t) {
    notDoneElements.add(t);
    notifyListeners();
  }

  void markItemAsDone(ToDoElement t) {
    if (notDoneElements.remove(t)) {
      doneElements.add(t);
    }
    notifyListeners();
  }

  void markItemAsUndone(ToDoElement t) {
    if (doneElements.remove(t)) {
      notDoneElements.add(t);
    }
    notifyListeners();
  }
}

class _ToDoListPageState extends State<ToDoListPage> {
  final _nameController = TextEditingController();
  final firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    //final todo = context.watch<ToDoListProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text("TODO List"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(children: [
                Expanded(
                    child: Column(children: [
                  Text("TODO"),
                  Expanded(
                    child: StreamBuilder(
                        stream:
                            firestoreService.getToDoUndoneStream(widget.tripId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final elements = snapshot.data!.docs;
                            return ListView.builder(
                              itemBuilder: (context, index) =>
                                  ToDoElementWidget(
                                      element: ToDoElement.fromJson(
                                          elements[index].data()
                                              as Map<String, dynamic>, elements[index].id), tripId: widget.tripId,),
                              itemCount: elements.length,
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )
                ])),
                VerticalDivider(
                  color: Colors.grey,
                  thickness: 1,
                  width: 20,
                ),
                Expanded(
                    child: Column(children: [
                  Text("DONE"),
                  Expanded(
                    child: StreamBuilder(
                        stream:
                            firestoreService.getToDoDoneStream(widget.tripId),
                        builder: (context, snapshot) {
                          if(snapshot.hasData)
                          {
                            final elements = snapshot.data!.docs;
                            return ListView.builder(
                            itemBuilder: (context, index) =>
                                ToDoDoneElementWidget(
                                    element: ToDoElement.fromJson(elements[index].data() as Map<String, dynamic>, elements[index].id), tripId: widget.tripId,),
                            itemCount: elements.length
                          );
                          }
                          else
                          {
                            return Container();
                          }
                        }),
                  )
                ]))
              ]),
            ),
            Row(children: [
              Expanded(
                  child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Add task"),
              )),
              IconButton(
                  onPressed: () async{
                    ToDoElement t = ToDoElement(description: _nameController.text);
                    String id = await firestoreService.addToDoUndoneItem(widget.tripId, t);
                    t.id = id;
                    _nameController.text = "";
                  },
                  icon: Icon(Icons.done))
            ])
          ],
        ));
  }
}

class ToDoElementWidget extends StatefulWidget {
  const ToDoElementWidget({super.key, required this.element, required this.tripId});
  final String tripId;
  final ToDoElement element;
  @override
  State<ToDoElementWidget> createState() => _ToDoElementWidgetState();
}

class _ToDoElementWidgetState extends State<ToDoElementWidget> {
  bool notificationOn = false;

  @override
  Widget build(BuildContext context) {    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.element.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () async{
                      final id = await FirestoreService().markItemAsDone(widget.tripId, widget.element);
                      widget.element.id = id;
                    },
                    icon: Icon(Icons.done),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        notificationOn = !notificationOn;
                      });
                    },
                    icon: Icon(notificationOn
                        ? Icons.notifications_off
                        : Icons.notification_add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToDoDoneElementWidget extends StatelessWidget {
  const ToDoDoneElementWidget({super.key, required this.element, required this.tripId});
  final String tripId;
  final ToDoElement element;
  @override
  Widget build(BuildContext context) {
    final todo = context.watch<ToDoListProvider>();
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        element.description,
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () async{
                           final id = await FirestoreService().markItemAsUndone(tripId, element);
                           element.id = id;
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ]))));
  }
}
