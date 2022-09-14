import 'package:flutter/material.dart';

import 'package:mynotes/services/hive/settings_service.dart';

import '../services/hive/boxes.dart';

import 'package:mynotes/main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  //White ver
  // final themes = ["Purple", "Green", "White"];
  final themes = ["Purple", "Green"];
  final currentTheme = "Purple";

  String? value = Boxes.getUserSettings().get("defaultKey")!.theme;
  @override
  Widget build(BuildContext context) {
    // else {
    //   textColor = Colors.white;
    // }

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
                dropdownColor: Colors.black,
                items: themes.map(buildMenuItem).toList(),
                value: value,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                  final box = Boxes.getUserSettings();
                  final userSetting = UserSettings(value ?? "Purple");

                  box.put("defaultKey", userSetting);
                },
              ),
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
          style: TextStyle(color: textColor),
        ),
      );
}
