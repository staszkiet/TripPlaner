import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripplaner/trip_list_page.dart';

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

  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
      await widget._auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(context.mounted)
      {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TripListPage()));
      }
   
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
      key: _formKey,
      child: Row(children: [
        Flexible(child: Container()),
        Flexible(
          flex:5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                               Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text(
                  "TripPlaner",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 45,),
                ),),
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
                SizedBox(width: 100, child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text);
                      }
                    },
                    child: const Text("Log in"))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 30), child:SignUpText()),
              ],
            )),
        Flexible(child: Container())
      ]),
    ));
  }
}

class RegistrationForm extends StatefulWidget {
  RegistrationForm({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  Future<void> register(
      {required BuildContext context,
      required String email,
      required String password}) async {
      await widget._auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(context.mounted)
      {
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TripListPage()));
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
              Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text(
                  "TripPlaner",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 45,),
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
                  child: const Text("Sign up")),
                 
            ],
          )), Flexible(flex:1, child:Container())])),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationForm()),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue, // Link color
                      decoration: TextDecoration.underline, // Underline the link
                    ),
                  ),
                ),
              ],
    );
  }
}