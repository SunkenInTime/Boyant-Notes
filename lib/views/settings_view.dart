import 'package:flutter/material.dart';

import 'package:mynotes/main.dart';
import 'package:mynotes/services/hive/settings_service.dart';

import '../services/hive/boxes.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final themes = ["Purple", "Green"];
  final currentTheme = "Purple";
  String? value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              const Text(
                "Themes",
                style: TextStyle(fontSize: 17),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              DropdownButton<String>(
                dropdownColor: Colors.black54,
                items: themes.map(buildMenuItem).toList(),
                value: value,
                onChanged: (value) {
                  setState(
                    () => this.value = value,
                  );
                  final box = Boxes.getUserSettings();
                  final userSetting = UserSettings(value ?? "Purple");

                  box.put("defaultKey", userSetting);
                  String text = box.get("defaultKey")!.theme;
                  print(text);
                },
              ),
              // DropdownButton<String>(
              //   value: currentTheme,
              //   items: themes.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //         style: TextStyle(color: Colors.black),
              //       ),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {

              //   },
              // )
            ],
          )
        ]),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String theme) => DropdownMenuItem(
        value: theme,
        child: Text(
          theme,
          style: const TextStyle(color: Colors.white),
        ),
      );
}
