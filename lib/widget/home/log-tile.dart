import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/style.dart';

class LogTile extends StatelessWidget {
  final String avatar;
  final String name;
  final double left;
  final double given;
  final double got;
  final String date;
  final bool monthly;
  final bool clear;
  const LogTile(
      {Key? key,
      required this.name,
      required this.left,
      required this.given,
      required this.got,
      required this.date,
      required this.avatar,
      required this.monthly,
      required this.clear})
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
                  Row(
                    children: [
                      Container(
                        height: kPad(context) * 0.06,
                        width: kPad(context) * 0.06,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(avatar != ''
                                    ? avatar
                                    : 'https://cdn.dribbble.com/userupload/4490588/file/original-4f9e9206872cebb3d98d5237ce64da37.png?compress=1&resize=1600x1200'),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        width: kPad(context) * 0.03,
                      ),
                      Text(
                        '$name - ${monthly ? 'Monthly' : 'Yearly'}',
                        style: style(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    clear ? 'Clear' : '',
                    style: style(context).copyWith(
                        color: Colors.green.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: kPad(context) * 0.03),
                  )
                ],
              ),
              SizedBox(
                height: kPad(context) * 0.05,
              ),
              Row(
                children: [
                  Text(
                    '₹ ${left.toStringAsFixed(2)}',
                    style:
                        style(context).copyWith(fontSize: kPad(context) * 0.06),
                  ),
                  SizedBox(
                    width: kPad(context) * 0.02,
                  ),
                  Text(
                    'LEFT',
                    style: style(context).copyWith(
                        fontSize: kPad(context) * 0.03,
                        color: darkC.withOpacity(0.5)),
                  ),
                ],
              ),
              SizedBox(
                height: kPad(context) * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.up_arrow,
                        color: Colors.redAccent,
                        size: kPad(context) * 0.035,
                      ),
                      SizedBox(
                        width: kPad(context) * 0.01,
                      ),
                      Text(
                        '₹ $given',
                        style: style(context)
                            .copyWith(fontSize: kPad(context) * 0.03),
                      ),
                      SizedBox(
                        width: kPad(context) * 0.05,
                      ),
                      Icon(
                        CupertinoIcons.down_arrow,
                        color: Colors.green,
                        size: kPad(context) * 0.035,
                      ),
                      SizedBox(
                        width: kPad(context) * 0.01,
                      ),
                      Text(
                        '₹ $got',
                        style: style(context)
                            .copyWith(fontSize: kPad(context) * 0.03),
                      )
                    ],
                  ),
                  Text(
                    date,
                    style: style(context).copyWith(
                        color: darkC.withOpacity(0.3),
                        fontWeight: FontWeight.bold,
                        fontSize: kPad(context) * 0.035),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
