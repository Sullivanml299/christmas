import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Keypad extends StatefulWidget {
  const Keypad({super.key, required this.validator});

  final Function validator;

  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {
  List<int?> code = [null, null, null, null];
  int index = 0;
  TextStyle keyStyle =
      const TextStyle(fontSize: 80, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.green,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 130, 0, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    makeCodeEntry(code[0]),
                    makeCodeEntry(code[1]),
                    makeCodeEntry(code[2]),
                    makeCodeEntry(code[3]),
                  ],
                )),
            gridBuilder(),
          ],
        ));
  }

  GridView gridBuilder() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        makeCard(
            Text(
              "1",
              style: keyStyle,
            ),
            addKey,
            1),
        makeCard(Text("2", style: keyStyle), addKey, 2),
        makeCard(Text("3", style: keyStyle), addKey, 3),
        makeCard(Text("4", style: keyStyle), addKey, 4),
        makeCard(Text("5", style: keyStyle), addKey, 5),
        makeCard(Text("6", style: keyStyle), addKey, 6),
        makeCard(Text("7", style: keyStyle), addKey, 7),
        makeCard(Text("8", style: keyStyle), addKey, 8),
        makeCard(Text("9", style: keyStyle), addKey, 9),
        makeCard(
            const Icon(
              Icons.cancel_outlined,
              size: 80,
            ),
            removeKey),
        makeCard(Text("0", style: keyStyle), addKey, 0),
        makeCard(
            const Icon(
              Icons.check,
              size: 80,
            ),
            validateClue,
            code.join()),
      ],
    );
  }

  Widget makeCodeEntry(dynamic value) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 6,
        height: MediaQuery.of(context).size.height / 10,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              value == null ? "___" : value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ));
  }

  Widget makeCard(Widget label, Function onPressed, [arg]) {
    return Card(
        child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      splashColor: index < code.length || onPressed == removeKey
          ? const Color.fromARGB(255, 0, 64, 255)
          : const Color.fromARGB(255, 255, 17, 0),
      onTap: () {
        arg == null ? onPressed() : onPressed(arg);
        print("code: $code");
        print("index $index");
      },
      child: Center(child: label),
    ));
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    print(isSolved);
    if (isSolved) {
      Navigator.of(context).pop();
    }
  }

  addKey(dynamic key) {
    if (index < code.length) {
      code[index] = key;
      setState(() {
        index++;
      });
    }
  }

  removeKey() {
    if (index > 0) {
      setState(() {
        index--;
        code[index] = null;
      });
    }
  }
}
