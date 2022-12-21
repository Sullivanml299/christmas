import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goblin_vault/clue_stepper.dart';
import 'package:goblin_vault/particle_canvas.dart';
import 'package:goblin_vault/rock_chart.dart';

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
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const Home(),
      },
      // home: const Home(), //DO NOT USE WITH NAMED ROUTING
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
        body: ClueStepper());
  }
}
