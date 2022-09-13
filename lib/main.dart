import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/hive/settings_service.dart';
import 'package:mynotes/themes/themes.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/main_ui.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/settings_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import "dart:developer" as devtools show log;

const double sizedBoxWidth = 300;
const double sizedBoxHeight = 300;

// const Color themeColor = Color.fromRGBO(85, 111, 68, 1);
const Color bgColor = Color.fromRGBO(20, 20, 20, 1);
const Color themeColor = Color.fromARGB(255, 107, 65, 114);
// const Color bgColor = Color.fromARGB(255, 31, 31, 31);

const Color defTextColor = Colors.white;
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserSettingsAdapter());
  await Hive.openBox<UserSettings>("user_settings");
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MyThemes.purpleTheme,
      debugShowCheckedModeBanner: false,
      home: const Setup(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const MainUIView(),
        verifyRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        forgotPasswordViewRoute: (context) => const ForgotPasswordView(),
        settingsRoute: (context) => const SettingsView(),
      },
    );
  }
}

class Setup extends StatelessWidget {
  const Setup({Key? key}) : super(key: key);

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
