import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "We've alredy sent you an email verification. Please check your email in order to verify your account.",
                textAlign: TextAlign.center,
              ),
              createSpace(10),
              const Text(
                "Haven't recieved an email yet?",
                textAlign: TextAlign.center,
              ),
              createSpace(10),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  await AuthService.firebase().sendVerification();
                },
                child: const Text("Resend email"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                  await AuthService.firebase().logOut();
                },
                child: const Text(
                  "Restart",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
