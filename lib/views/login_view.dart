// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../main.dart';
import '../utilities/dialogs/show_error_dialog.dart';

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

    //intialize();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 210,
                child: Image(
                  image: AssetImage("assets/Boyant Icon.png"),
                ),
              ),
              //Email
              SizedBox(
                width: sizedBoxWidth,
                height: sizedBoxHeight,
                child: TextField(
                  controller: _email,
                  enableSuggestions: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Email",
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
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 167, 167, 167),
                        width: 2,
                      ),
                    ),
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
                    foregroundColor: defTextColor,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );

                      final user = AuthService.firebase().currentUser;

                      if (user?.isEmailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          notesRoute,
                          (route) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyRoute,
                          (route) => false,
                        );
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        "User not found",
                      );
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Wrong password",
                      );
                    } on ConnectionFailedAuthException {
                      await showErrorDialog(
                        context,
                        "Could not connect to server check if your device is connected to the internet.",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Authentication error",
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text("Not signed up?"),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: defTextColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    forgotPasswordViewRoute,
                  );
                },
                child: const Text("Forgot password?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
