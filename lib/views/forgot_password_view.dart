import 'package:flutter/material.dart';

import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/dialogs/show_error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const resetSnackBar =
        SnackBar(content: Text("Password reset email has been sent!"));
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: themeColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: sizedBoxWidth,
                height: 55,
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
              createSpace(10),
              SizedBox(
                width: sizedBoxWidth,
                height: 55,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: themeColor),
                  onPressed: () async {
                    try {
                      await AuthService.firebase()
                          .resetPassword(email: _email.text);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(resetSnackBar);
                    } on PasswordResetAuthException {
                      await showErrorDialog(
                        context,
                        "User not found",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Authentication error",
                      );
                    }
                  },
                  child: const Text("Reset"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
