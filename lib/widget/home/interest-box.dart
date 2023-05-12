import 'package:flutter/material.dart';

import '../../common/style.dart';

class InterestBox extends StatelessWidget {
  final String text;
  final double money;
  final IconData icon;
  final Color color;

  const InterestBox(
      {super.key,
      required this.text,
      required this.money,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 20,
      shadowColor: primaryColor(context).withOpacity(0.05),
      child: Container(
        height: kPad(context) * 0.4,
        width: kPad(context) * 0.4,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(kPad(context) * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: kPad(context) * 0.15,
              width: kPad(context) * 0.15,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color.withOpacity(0.5), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  shape: BoxShape.circle),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹ $money',
                  style: style(context).copyWith(
                      color: darkC.withOpacity(0.7),
                      fontSize: kPad(context) * 0.04,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  style: style(context).copyWith(
                      color: darkC.withOpacity(0.6),
                      fontSize: kPad(context) * 0.03),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
