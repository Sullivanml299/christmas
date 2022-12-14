import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late TextEditingController _controller;
  List<bool> tracker = clueTracker;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  submit(String value) {
    print("VALUE: $value");
    // validate();
  }

  bool validate(String password) {
    print(password);
    print(widget.data.password);
    if (password == widget.data.password) {
      widget.notifier();
      tracker[widget.data.index] = true;
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
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scanner(
                                validator: validate,
                              )),
                    );
                  },
                  icon: const Icon(Icons.scanner),
                  label: const Text("scanner"))
            ],
          )
          // Row(
          //   children: [
          //     Expanded(
          //         child: TextField(
          //             controller: _controller,
          //             onSubmitted: ((String value) => submit(value)))),
          //   ],
          // )
        ],
      ),
    ));
  }
}
