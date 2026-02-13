import 'package:flutter/material.dart';
import 'package:focus_timer/data/constants.dart';

class WeekDays extends StatelessWidget {
  const WeekDays({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(color: Colors.grey.shade700);

    Widget text (String txt) {
      return Expanded(child: Text(txt, textAlign: TextAlign.center, style: textStyle,));
    }
    return SizedBox(
      height: defPadding*3,
      child: Row(
        children: [
         text('Mon'),
        text('Tue'),
        text('Wed'),
        text('Thu'),
        text('Fri'),
        text('Sat'),
          text('Sun'),
        ],
      ),
    );
  }
}
