import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/main_ui.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import "dart:developer" as devtools show log;

const double sizedBoxWidth = 300;
const double sizedBoxHeight = 300;
const Color themeColor = Color.fromARGB(255, 107, 65, 114);
const Color bgColor = Color.fromARGB(255, 31, 31, 31);
dynamic loadingCircle;
late Icon shareIcon;
//Creates an empty sized box for sapce
SizedBox createSpace(double height) {
  return SizedBox(height: height);
}

SizedBox createSpaceWidth(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
        primaryColor: bgColor,
        secondaryHeaderColor: themeColor,
        unselectedWidgetColor: const Color.fromARGB(255, 102, 102, 102),
        iconTheme: const IconThemeData(color: Colors.grey)),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const MainUIView(),
      verifyRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainUIView();
              } else {
                devtools.log(user.toString());
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            if (Platform.isIOS) {
              loadingCircle = const CupertinoActivityIndicator();
              shareIcon = const Icon(Icons.ios_share);
            } else {
              loadingCircle = const CircularProgressIndicator();
              shareIcon = const Icon(Icons.share);
            }
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 180, 180, 180),
              body: Center(
                child: SizedBox(
                  width: sizedBoxWidth,
                  height: sizedBoxHeight,
                  child: Center(child: loadingCircle),
                ),
              ),
            );
        }
      },
    );
  }
}
