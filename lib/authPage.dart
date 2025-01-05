import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tripplaner/tripListPage.dart';
import 'package:tripplaner/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "TripPlaner",
                style: TextStyle(fontSize: 50),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => registrationForm()));
              },
              child: Text("Register"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginForm()));
              },
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () {
                  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => TripListPage()));
              },
              child: Text("Debug"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<List<Trip>> fetchTrips() async {
  try {
    final QuerySnapshot snapshot = 
        await FirebaseFirestore.instance.collection('Trips').get();

    return snapshot.docs.map((doc) {
      return Trip.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error fetching trips: $e');
    return [];
  }
}

  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await widget._auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final trips = await fetchTrips();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TripListPage()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
      key: _formKey,
      child: Row(children: [
        Flexible(flex: 1, child: Container()),
        Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Log in:",
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Incorrect format";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text);
                      }
                    },
                    child: const Text("Log in"))
              ],
            )),
        Flexible(flex: 1, child: Container())
      ]),
    ));
  }
}

class registrationForm extends StatefulWidget {
  registrationForm({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<registrationForm> createState() => _registrationFormState();
}

class _registrationFormState extends State<registrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  Future<void> register(
      {required BuildContext context,
      required String email,
      required String password}) async {
    print("here");
    try {
      await widget._auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User registered successfully!");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TripListPage()));
    } catch (e) {
      print("Registration error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
          key: _formKey,
          child:Row(children: [Flexible(flex:1, child:Container()),Flexible(flex:3, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(bottom: 10), child:Text(
                  "Register:",
                  style: TextStyle(fontSize: 30),
                ),),
              Padding(padding: EdgeInsets.symmetric(vertical: 10), 
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Incorrect format";
                    }
                    return null;
                  },
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10), 
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      return null;
                    },
                  ),),
              Padding(padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _passwordRepeatController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      register(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text);
                    }
                  },
                  child: const Text("Add"))
            ],
          )), Flexible(flex:1, child:Container())])),
    );
  }
}
