// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double sizedBoxWidth = 300;
    const double sizedBoxHeight = 50;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 31, 31, 31),
        appBar: AppBar(
          title: const Text("Register"),
          backgroundColor: const Color.fromARGB(255, 107, 65, 114),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Email
                      SizedBox(
                        width: sizedBoxWidth,
                        height: sizedBoxHeight,
                        child: TextField(
                          controller: _email,
                          enableSuggestions: true,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  width: 2),
                            ),
                            border: OutlineInputBorder(),
                            //focusedBorder:OutlineInputBorder(borderSide: BorderSide(width: 1))
                          ),
                        ),
                      ),

                      //Spacing
                      const SizedBox(height: 10),

                      //Password
                      SizedBox(
                        width: sizedBoxWidth,
                        height: sizedBoxHeight,
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _password,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 167, 167, 167),
                                  width: 2),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: sizedBoxWidth,
                        height: sizedBoxHeight,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 107, 65, 114)),
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);

                                print(userCredential);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == "email-already-in-use") {
                                  print("Email already in use");
                                } else if (e.code == "network-request-failed") {
                                  print("Could not connect to server");
                                } else if (e.code == "weak-password") {
                                  print("Weak Password");
                                } else if (e.code == "invalid-email") {
                                  print("Invalid email");
                                }
                              }
                            },
                            child: const Text('Register')),
                      ),
                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}
