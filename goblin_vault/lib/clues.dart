import 'package:flutter/material.dart';
import 'package:goblin_vault/clue.dart';
import 'package:goblin_vault/qr_scanner.dart';

class ClueData {
  ClueData({required this.prompt, required this.password, required this.index});

  String prompt;
  bool isSolved = false;
  String password;
  int index;
}

ClueData C1 = ClueData(prompt: "Riddle 1", password: "password1", index: 0),
    C2 = ClueData(prompt: "Riddle 2", password: "password2", index: 1),
    C3 = ClueData(prompt: "Riddle 3", password: "password3", index: 2),
    C4 = ClueData(prompt: "Riddle 4", password: "password4", index: 3);

List<ClueData> CLUE_DATA = [C1, C2, C3, C4];

List<bool> clueTracker = List.filled(CLUE_DATA.length, false);
