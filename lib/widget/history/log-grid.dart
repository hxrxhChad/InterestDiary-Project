import 'package:flutter/material.dart';

import '../../common/style.dart';

class LogGrid extends StatelessWidget {
  final String name;
  final Color color;
  final double money;
  const LogGrid(
      {Key? key, required this.name, required this.color, required this.money})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: style(context)
              .copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          '₹ ${money.toStringAsFixed(2)}',
          style: style(context).copyWith(
              fontSize: kPad(context) * 0.08, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
