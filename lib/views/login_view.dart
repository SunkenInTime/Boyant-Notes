import "dart:developer" as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

import '../main.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    const man = true;
    //intialize();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color.fromARGB(255, 107, 65, 114),
      ),
      body: Center(
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
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 167, 167, 167), width: 2),
                  ),
                  border: OutlineInputBorder(),
                  //focusedBorder:OutlineInputBorder(borderSide: BorderSide(width: 1))
                ),
              ),
            ),

            //Spacing
            createSpace(10),

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
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 167, 167, 167), width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),

            //Spacing
            createSpace(10),

            SizedBox(
              width: sizedBoxWidth,
              height: sizedBoxHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 107, 65, 114)),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (!man) {} //used this to escape an error i have no idea how to fix :skull:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "user-not-found") {
                      await showErrorDialog(
                        context,
                        "User not found",
                      );
                    } else if (e.code == "wrong-password") {
                      await showErrorDialog(
                        context,
                        "Wrong password",
                      );
                    } else if (e.code == "network-request-failed") {
                      await showErrorDialog(
                        context,
                        "Could not connect to server check if your device is connected to the internet.",
                      );
                    } else {
                      await showErrorDialog(
                        context,
                        "Error: ${e.code}",
                      );
                      devtools.log("Something wrong happened");
                      devtools.log(e.code);
                    }
                  } catch (e) {
                    await showErrorDialog(
                      context,
                      "Error ${e.toString()}",
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ),

            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text("Not signed up?"))
          ],
        ),
      ),
    );
  }
}
