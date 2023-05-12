import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style.dart';

class HistoryTile extends StatelessWidget {
  final double amount;
  final String time;
  final bool got;
  final String msg;

  const HistoryTile(
      {Key? key,
      required this.amount,
      required this.time,
      required this.got,
      required this.msg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: darkC.withOpacity(0.07),
      ))),
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kPad(context) * 0.09, vertical: kPad(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ $amount',
                        style: style(context)
                            .copyWith(fontSize: kPad(context) * 0.06),
                      ),
                      Text(
                        time,
                        style: style(context).copyWith(
                            color: darkC.withOpacity(0.3),
                            fontWeight: FontWeight.bold,
                            fontSize: kPad(context) * 0.03),
                      )
                    ],
                  ),
                  Container(
                    height: kPad(context) * 0.1,
                    width: kPad(context) * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: got
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3)),
                    child: Icon(
                      got ? CupertinoIcons.down_arrow : CupertinoIcons.up_arrow,
                      size: kPad(context) * 0.04,
                      color: got ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kPad(context) * 0.05,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.text_alignleft,
                    color: primaryColor(context),
                    size: kPad(context) * 0.035,
                  ),
                  SizedBox(
                    width: kPad(context) * 0.02,
                  ),
                  Expanded(
                    child: Text(
                      msg,
                      style: style(context).copyWith(
                          color: darkC.withOpacity(0.3),
                          fontSize: kPad(context) * 0.03),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
