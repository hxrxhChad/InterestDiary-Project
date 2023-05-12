import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:intl/intl.dart';
import 'package:khatadiary/service/firebase/add.dart';
import 'package:khatadiary/widget/add-client/field.dart';

import '../common/style.dart';

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  bool monthly = false;
  bool yearly = false;
  String name = '';
  double amount = 0;
  bool sending = false;

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: kPad(context) * 0.2,
        elevation: 0,
        backgroundColor: scaffoldColor(context),
        leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.1),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: darkC,
            )),
        title: Text(
          'Add Client',
          style: style(context).copyWith(
              fontSize: kPad(context) * 0.05, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kPad(context) * 0.1,
            ),
            Field(
              hint: 'Name',
              initialValue: '',
              onChanged: (v) {
                setState(() {
                  name = v;
                });
              },
              name: 'Name',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: kPad(context) * 0.1,
            ),
            Field(
              hint: 'Amount',
              initialValue: '',
              onChanged: (v) {
                amount = double.parse(v);
              },
              name: 'Amount',
              keyboardType: TextInputType.number,
            ),
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
                              monthly = v;
                              yearly = !v;
                            });
                          },
                          value: monthly),
                      SizedBox(
                        width: kPad(context) * 0.025,
                      ),
                      Text(
                        'Montly Interest',
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
                              yearly = v;
                              monthly = !v;
                            });
                          },
                          value: yearly),
                      SizedBox(
                        width: kPad(context) * 0.025,
                      ),
                      Text(
                        'Yearly Interest',
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
            Align(
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
                  await addClient(name, amount, monthly,
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
            )
          ],
        ),
      ),
    );
  }
}
