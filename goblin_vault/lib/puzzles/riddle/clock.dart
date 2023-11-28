import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key, required this.validator});

  final Function validator;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  TimeOfDay? time;
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              child: Text(
                  "An odd set of twins wanted to play music and sing. They both had violins, but one was missing a string."),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                  onPressed: () => showClock(),
                  child: time == null
                      ? const Text("Access Clock")
                      : const Text("Try Again")),
            ),
            showHint
                ? const Text(
                    "Hint: Kurama's tails can count the minutes but not the hour.")
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showHint = true;
                      });
                    },
                    child: const Text("Hint"))
          ],
        ),
      ),
    );
  }

  showClock() async {
    var newTime = await showTimePicker(
        context: context,
        initialTime: time ?? const TimeOfDay(hour: 0, minute: 0),
        initialEntryMode: TimePickerEntryMode.dialOnly,
        builder: (BuildContext context, Widget? child) {
          return Directionality(
              textDirection: TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ));
        });

    validateClue(newTime);
    setState(() {
      time = newTime;
    });
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    print(isSolved);
    if (isSolved) {
      Navigator.of(context).pop();
    }
  }
}
