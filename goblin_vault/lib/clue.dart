import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goblin_vault/clock.dart';
import 'package:goblin_vault/clues.dart';
import 'package:goblin_vault/qr_scanner.dart';

class Clue extends StatefulWidget {
  const Clue({super.key, required this.data, required this.notifier});

  final ClueData data;
  final Function notifier;

  @override
  State<Clue> createState() => _ClueState();
}

class _ClueState extends State<Clue> {
  List<bool> tracker = clueTracker;

  @override
  void initState() {
    super.initState();
  }

  bool validate(dynamic password) {
    if (password == widget.data.password) {
      widget.notifier();
      tracker[widget.data.index] = true;
      widget.data.isSolved = true;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ClueData data = widget.data;
    return FittedBox(
        child: SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        children: [
          Row(children: [
            Text(data.prompt),
          ]),
          Row(
            children: [getChallenge()],
          )
        ],
      ),
    ));
  }

  Widget getChallenge() {
    if (widget.data.isSolved) {
      return const Text(
        "Challenge Complete!",
        style: TextStyle(color: Color.fromARGB(255, 0, 251, 255), fontSize: 20),
      );
    }
    return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.data.solver(
                      validate,
                    )),
          );
        },
        icon: getIcon(widget.data.solver),
        label: const Text("Begin"));
  }

  Icon getIcon(Function solver) {
    if (solver == CLOCK) return const Icon(Icons.access_time_filled);
    if (solver == SCANNER) return const Icon(Icons.camera);
    if (solver == KEYPAD) return const Icon(Icons.password);
    if (solver == STOPANDGO) return const Icon(Icons.preview);
    if (solver == HIDEANDSEEK) return const Icon(Icons.my_location);
    if (solver == PUZZLE) return const Icon(Icons.image);
    if (solver == PLANETPUZZLE) return const Icon(Icons.sunny);
    return const Icon(Icons.zoom_out_map);
  }
}
