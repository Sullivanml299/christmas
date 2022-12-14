import 'package:flutter/material.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/qr_scanner.dart';

import 'clock.dart';

class ClueData {
  ClueData(
      {required this.prompt,
      required this.password,
      required this.index,
      required this.solver});

  String prompt;
  bool isSolved = false;
  dynamic password;
  int index;
  var solver;
}

var scanner = (Function validator) => Scanner(validator: validator);
var clock = (Function validator) => Clock(validator: validator);

ClueData C1 = ClueData(
        prompt: "Riddle 1", password: "password1", index: 0, solver: scanner),
    C2 = ClueData(
        prompt: "Riddle 2",
        password: const TimeOfDay(hour: 14, minute: 12),
        index: 1,
        solver: clock),
    C3 = ClueData(
        prompt: "Riddle 3", password: "password3", index: 2, solver: scanner),
    C4 = ClueData(
        prompt: "Riddle 4", password: "password4", index: 3, solver: scanner);

List<ClueData> CLUE_DATA = [C1, C2, C3, C4];

List<bool> clueTracker = List.filled(CLUE_DATA.length, false);
