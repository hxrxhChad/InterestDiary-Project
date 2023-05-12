import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:intl/intl.dart';

import '../common/style.dart';
import '../service/firebase/add.dart';
import '../service/firebase/update.dart';
import '../widget/add-client/field.dart';

class AddHistory extends StatefulWidget {
  final String id;
  const AddHistory({Key? key, required this.id}) : super(key: key);

  @override
  State<AddHistory> createState() => _AddHistoryState();
}

class _AddHistoryState extends State<AddHistory> {
  double amount = 0;
  bool send = false;
  bool receive = false;
  bool sending = false;
  String remarks = '';

  //
  DateTime selectedDate = DateTime.now();
  int selectedMilliseconds = 0;

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedMilliseconds = selectedDate.millisecondsSinceEpoch;
      });
      debugPrint(
          '${DateTime.now().millisecondsSinceEpoch} >>> $selectedMilliseconds');
      debugPrint(
          '${DateFormat('dd MMMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse('${DateTime.now().millisecondsSinceEpoch}')))} >>> ${DateFormat('dd MMMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse('$selectedMilliseconds')))}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kPad(context) * 1.7,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kPad(context) * 0.2,
            ),
            Field(
                hint: 'Amount',
                initialValue: '',
                onChanged: (v) {
                  setState(() {
                    amount = double.parse(v);
                  });
                },
                name: 'Amount',
                keyboardType: TextInputType.number),
            SizedBox(
              height: kPad(context) * 0.1,
            ),
            Field(
                hint: 'Remarks',
                initialValue: '',
                onChanged: (v) {
                  setState(() {
                    remarks = v;
                  });
                },
                name: 'Remarks',
                keyboardType: TextInputType.text),
            SizedBox(
              height: kPad(context) * 0.1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GFCheckbox(
                          size: kPad(context) * 0.06,
                          type: GFCheckboxType.circle,
                          activeBgColor: Colors.blue,
                          onChanged: (v) {
                            setState(() {
                              receive = v;
                              send = !v;
                            });
                          },
                          value: receive),
                      SizedBox(
                        width: kPad(context) * 0.025,
                      ),
                      Text(
                        'Receiving',
                        style: style(context),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      GFCheckbox(
                          size: kPad(context) * 0.06,
                          type: GFCheckboxType.circle,
                          activeBgColor: Colors.blue,
                          onChanged: (v) {
                            setState(() {
                              send = v;
                              receive = !v;
                            });
                          },
                          value: send),
                      SizedBox(
                        width: kPad(context) * 0.025,
                      ),
                      Text(
                        'Sending',
                        style: style(context),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kPad(context) * 0.1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Loan',
                    style:
                        style(context).copyWith(fontSize: kPad(context) * 0.04),
                  ),
                  SizedBox(
                    height: kPad(context) * 0.01,
                  ),
                  Text(
                    selectedMilliseconds == 0
                        ? DateFormat('dd MMMM, yyyy').format(DateTime.now())
                        : DateFormat('dd MMMM, yyyy').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse('$selectedMilliseconds'))),
                    style: style(context).copyWith(
                        fontSize: kPad(context) * 0.05,
                        color: darkC.withOpacity(0.5)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: kPad(context) * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(left: kPad(context) * 0.06),
              child: TextButton(
                  onPressed: () => _showDatePicker(),
                  child: const Text('Choose Date')),
            ),
            SizedBox(
              height: kPad(context) * 0.2,
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream:
                    firestore.collection('client').doc(widget.id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox(
                      height: 0,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    Map<String, dynamic>? data = snapshot.data!.data();
                    //
                    return Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: shadowColor(context).withOpacity(0.5),
                            backgroundColor: scaffoldColor(context),
                            side: BorderSide(
                                color: shadowColor(context).withOpacity(0.1)),
                            elevation: 0),
                        onPressed: () async {
                          setState(() {
                            sending = true;
                          });
                          await addHistory(widget.id, amount, remarks, receive,
                              '${selectedMilliseconds == 0 ? DateTime.now().millisecondsSinceEpoch : selectedMilliseconds}');
                          await updateLog(
                                  widget.id,
                                  receive
                                      ? data!['amount'] - amount
                                      : data!['amount'] + amount,
                                  receive
                                      ? data!['totalInvestment']
                                      : data!['totalInvestment'] + amount,
                                  receive
                                      ? data!['amount'] - amount
                                      : data!['amount'] + amount,
                                  receive
                                      ? data['received'] + amount
                                      : data['received'],
                                  '${selectedMilliseconds == 0 ? DateTime.now().millisecondsSinceEpoch : selectedMilliseconds}')
                              .whenComplete(() {
                            setState(() {
                              sending = false;
                            });
                            Navigator.pop(context);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kPad(context) * 0.05,
                              vertical: kPad(context) * 0.04),
                          child: sending
                              ? SizedBox(
                                  height: kPad(context) * 0.04,
                                  width: kPad(context) * 0.04,
                                  child: const CircularProgressIndicator(
                                    color: darkC,
                                    strokeWidth: 1,
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: style(context)
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    );
                    //
                  }
                  return const SizedBox(
                    height: 0,
                  );
                })
          ],
        ),
      ),
    );
  }
}
