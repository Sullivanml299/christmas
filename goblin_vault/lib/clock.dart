import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key, required this.validator});

  final Function validator;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  TimeOfDay? time;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () => showClock(),
            child: time == null
                ? const Text("Access Clock")
                : Text(time.toString())));
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
