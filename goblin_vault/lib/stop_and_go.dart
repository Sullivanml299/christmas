import 'package:flutter/material.dart';
import 'package:goblin_vault/stop_and_go_timer.dart';

class StopAndGo extends StatefulWidget {
  const StopAndGo({super.key});

  @override
  State<StopAndGo> createState() => _StopAndGoState();
}

class _StopAndGoState extends State<StopAndGo> {
  @override
  Widget build(BuildContext context) {
    return const StopAndGoTimer();
  }
}
