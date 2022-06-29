import "dart:developer" as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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

  // FutureBuilder intialize() {
  //   return FutureBuilder(
  //     future: Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     ),
  //     builder: (context, snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.done:
  //           final user = FirebaseAuth.instance.currentUser;
  //           if (user != null) {
  //             if (user.emailVerified) {
  //               return const Text("");
  //             } else {
  //               return const Text("");
  //             }
  //           } else {
  //             return const LoginView();
  //           }

  //         default:
  //           return const CircularProgressIndicator();
  //       }
  //     },
  //   );
  // }

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

            const SizedBox(height: 10),

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
                      "/notes/",
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "user-not-found") {
                      devtools.log("User not found");
                    } else if (e.code == "wrong-password") {
                      devtools.log("Wrong password");
                    } else {
                      devtools.log("Something wrong happened");
                      devtools.log(e.code);
                    }
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
                    '/register/',
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
