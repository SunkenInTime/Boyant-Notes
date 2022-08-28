import 'package:flutter/material.dart';

import 'package:mynotes/main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final themes = ["Purple", "Green"];
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
                style: TextStyle(color: defTextColor, fontSize: 17),
              ),
              // DropdownButton<String>(items: themes.map(buildMenuItem).toList(), onChanged: () {})
            ],
          )
        ]),
      ),
    );
  }
}
