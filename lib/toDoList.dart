import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDoElement {
  final String description;
  bool done = false;
  ToDoElement({required this.description, bool done = false})
  {
    this.done = done;
  }

    factory ToDoElement.fromJson(Map<String, dynamic> json) {
    return ToDoElement(
      description: json['description'],
      done: json['done'] ?? false, // Default to false if 'done' is missing
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
  const ToDoListPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<ToDoListProvider>();
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
                      child: ListView.builder(
                    itemBuilder: (context, index) =>
                        ToDoElementWidget(element: todo.notDoneElements[index]),
                    itemCount: todo.notDoneElements.length,
                  )),
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
                    child: ListView.builder(
                      itemBuilder: (context, index) => ToDoDoneElementWidget(
                          element: todo.doneElements[index]),
                      itemCount: todo.doneElements.length,
                    ),
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
                  onPressed: () {
                    todo.addItem(
                        ToDoElement(description: _nameController.text));
                    _nameController.text = "";
                  },
                  icon: Icon(Icons.done))
            ])
          ],
        ));
  }
}

class ToDoElementWidget extends StatefulWidget {
  const ToDoElementWidget({super.key, required this.element});

  final ToDoElement element;
  @override
  State<ToDoElementWidget> createState() => _ToDoElementWidgetState();
}

class _ToDoElementWidgetState extends State<ToDoElementWidget> {
  bool notificationOn = false;

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<ToDoListProvider>();
    return Padding(
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
                    onPressed: () {
                      todo.markItemAsDone(widget.element);
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
  const ToDoDoneElementWidget({super.key, required this.element});
  final ToDoElement element;
  @override
  Widget build(BuildContext context) {
    final todo = context.watch<ToDoListProvider>();
    return Padding(
        padding: EdgeInsets.symmetric(vertical:8.0, horizontal: 16.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(padding: EdgeInsets.all(8.0), child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(element.description, style: TextStyle(fontSize: 16),),
                  IconButton(
                    onPressed: () {
                      todo.markItemAsUndone(element);
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ]))));
  }
}
