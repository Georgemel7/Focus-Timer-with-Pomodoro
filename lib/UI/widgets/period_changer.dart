import 'package:flutter/material.dart';

import '../../controllers/stats_controller.dart';

class PeriodChanger extends StatelessWidget {

  final StatsController controller;


  const PeriodChanger(this.controller, {super.key});



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            controller.previous();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        Text(
          controller.period.toString()
        ),
        IconButton(
          onPressed: () {
            controller.next();
          },
          icon: const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ],
    );
  }
}
