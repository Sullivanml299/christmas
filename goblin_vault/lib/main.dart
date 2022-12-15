import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goblin_vault/clock.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/clue_stepper.dart';
import 'package:goblin_vault/hide_and_seek.dart';
import 'package:goblin_vault/keypad.dart';
import 'package:goblin_vault/qr_scanner.dart';
import 'package:goblin_vault/stop_and_go.dart';

import 'clues.dart';
import 'package:flutter/material.dart';
import 'color_schemes.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // appBar: AppBar(
        //   elevation: 2,
        //   title: Text("Material Theme Builder"),
        // ),
        body: HideAndSeek()); //StopAndGo()); //ClueStepper());
  }
}
