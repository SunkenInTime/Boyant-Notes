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







// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) {
//         return CounterBloc();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Testing bloc"),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidValue : "";

//             return Column(
//               children: [
//                 Text("Current value = ${state.value}"),
//                 Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child: Text("Invalid value $invalidValue"),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration:
//                       const InputDecoration(hintText: "Enter a number here"),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           context
//                               .read<CounterBloc>()
//                               .add(DecrementEvent(_controller.text));
//                         },
//                         icon: const Icon(Icons.remove)),
//                     IconButton(
//                         onPressed: () {
//                           context
//                               .read<CounterBloc>()
//                               .add(IncrementEvent(_controller.text));
//                         },
//                         icon: const Icon(Icons.add))
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;

//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;

//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidValue: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           emit(CounterStateValid(state.value + integer));
//         }
//       },
//     );
//     on<DecrementEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidValue: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           emit(CounterStateValid(state.value - integer));
//         }
//       },
//     );
//   }
// }
