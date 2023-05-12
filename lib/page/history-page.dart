// ignore_for_file: file_names

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:khatadiary/page/add-history.dart';
import 'package:khatadiary/page/control-page.dart';
import 'package:khatadiary/widget/function/navigator.dart';
import 'package:khatadiary/widget/history/log-grid.dart';

import '../common/style.dart';
import '../service/firebase/add.dart';
import '../widget/history/history-tile.dart';

class HistoryPage extends StatelessWidget {
  final String id;
  final String name;
  const HistoryPage({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: kPad(context) * 0.15,
          elevation: 0,
          backgroundColor: scaffoldColor(context),
          centerTitle: true,
          leading: IconButton(
              padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.1),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                CupertinoIcons.left_chevron,
                color: darkC,
              )),
          title: Text(
            name,
            style: style(context).copyWith(
                color: darkC.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                fontSize: kPad(context) * 0.05),
          ),
          automaticallyImplyLeading: true,
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.08),
                child: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Client',
                            style: style(context).copyWith(
                                fontSize: kPad(context) * 0.05,
                                fontWeight: FontWeight.bold)),
                        content: Text(
                          'Do you really want to delete this Client?',
                          style: style(context)
                              .copyWith(color: darkC.withOpacity(0.5)),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'No',
                              style: style(context).copyWith(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  fontSize: kPad(context) * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(
                              'Yes',
                              style: style(context).copyWith(
                                  color: Colors.blueAccent,
                                  fontSize: kPad(context) * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              await firestore
                                  .collection('client')
                                  .doc(id)
                                  .delete()
                                  .whenComplete(() =>
                                      replace(context, const ControlPage()));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(
                    AntIcons.deleteOutlined,
                    color: darkC.withOpacity(0.5),
                    size: kPad(context) * 0.05,
                  ),
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: scaffoldColor(context),
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return AddHistory(
                  id: id,
                );
              }),
          child: Material(
            elevation: 10,
            shadowColor: primaryColor(context).withOpacity(0.4),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: kPad(context) * 0.13,
              width: kPad(context) * 0.3,
              decoration: BoxDecoration(
                  color: primaryColor(context),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: kPad(context) * 0.06,
                  ),
                  SizedBox(
                    width: kPad(context) * 0.02,
                  ),
                  Text('Add',
                      style: style(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: kPad(context) * 0.05,
                      ))
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: firestore.collection('client').doc(id).snapshots(),
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
                      DateTime loanTime = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(data!['loanTime']));
                      String time = DateFormat('jm').format(loanTime);
                      String date =
                          DateFormat('dd MMMM, yyyy').format(loanTime);
                      String newTime = '$time on $date';

                      //
                      DateTime today = DateTime.now();
                      DateTime principalDay =
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(data['time']));
                      Duration difference = today.difference(principalDay);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: kPad(context) * 0.05,
                            horizontal: kPad(context) * 0.1),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Loan Amount',
                                      style: style(context).copyWith(
                                          color: primaryColor(context),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '₹ ${data!['loan']}',
                                      style: style(context).copyWith(
                                          fontSize: kPad(context) * 0.08,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      newTime,
                                      style: style(context).copyWith(
                                          color: shadowColor(context)
                                              .withOpacity(0.4),
                                          fontSize: kPad(context) * 0.03),
                                    ),
                                  ],
                                ),
                                LogGrid(
                                    name: 'Received till Date',
                                    color: Colors.purple.withOpacity(0.8),
                                    money: data['received']),
                              ],
                            ),
                            SizedBox(
                              height: kPad(context) * 0.07,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LogGrid(
                                      name: 'Rest Amount to get',
                                      color: Colors.orange.withOpacity(0.8),
                                      money: data['amount']),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Days of Interest',
                                        style: style(context).copyWith(
                                            color: Colors.redAccent
                                                .withOpacity(0.4),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${difference.inDays} ${difference.inDays < 2 ? 'Day' : 'Days'}',
                                        style: style(context).copyWith(
                                            fontSize: kPad(context) * 0.08,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ]),
                            SizedBox(
                              height: kPad(context) * 0.07,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      DocumentSnapshot docSnapshot =
                                          await firestore
                                              .collection('client')
                                              .doc(id)
                                              .get();
                                      if (docSnapshot.exists) {
                                        Map<String, dynamic>? data = docSnapshot
                                            .data() as Map<String, dynamic>?;
                                        // Get the value of a specific key
                                        dynamic value = data?['clear'];
                                        await firestore
                                            .collection('client')
                                            .doc(id)
                                            .update({"clear": !data?['clear']});
                                      } else {
                                        debugPrint('Document does not exist.');
                                      }
                                    },
                                    child: Text(data['clear']
                                        ? 'Unmark Cleared'
                                        : 'Mark Cleared')),
                                Icon(
                                  data['clear']
                                      ? AntIcons.checkOutlined
                                      : CupertinoIcons.multiply,
                                  color: data['clear']
                                      ? Colors.green
                                      : Colors.redAccent,
                                )
                              ],
                            )
                          ],
                        ),
                      );
                      //
                    }
                    return const SizedBox(
                      height: 0,
                    );
                  }),
              SizedBox(
                height: kPad(context) * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kPad(context) * 0.1,
                    vertical: kPad(context) * 0.02),
                child: Text(
                  'Money History',
                  style: style(context).copyWith(
                      color: shadowColor(context).withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: kPad(context) * 0.05),
                ),
              ),
              StreamBuilder(
                  stream: firestore
                      .collection('client')
                      .doc(id)
                      .collection('history')
                      .orderBy('id', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? const SizedBox(
                            height: 0,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index].data();
                              DateTime nTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(data['time']));
                              String time = DateFormat('jm').format(nTime);
                              String date =
                                  DateFormat('dd MMMM, yyyy').format(nTime);
                              String newTime = '$time on $date';
                              return Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Delete History',
                                                style: style(context).copyWith(
                                                    fontSize:
                                                        kPad(context) * 0.05,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: Text(
                                              'Do you really want to delete this history?',
                                              style: style(context).copyWith(
                                                  color:
                                                      darkC.withOpacity(0.5)),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'No',
                                                  style: style(context)
                                                      .copyWith(
                                                          color: Colors
                                                              .redAccent
                                                              .withOpacity(0.6),
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.05,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Yes',
                                                  style: style(context)
                                                      .copyWith(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontSize:
                                                              kPad(context) *
                                                                  0.05,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                onPressed: () async {
                                                  await firestore
                                                      .collection('client')
                                                      .doc(id)
                                                      .collection('history')
                                                      .doc(data['id'])
                                                      .delete()
                                                      .whenComplete(() =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: AntIcons.deleteFilled,
                                      backgroundColor: Colors.red.shade300,
                                    )
                                  ],
                                ),
                                child: HistoryTile(
                                  amount: data['amount'],
                                  time: newTime,
                                  got: data['got'],
                                  msg: data['remarks'],
                                ),
                              );
                            });
                  }),
            ],
          ),
        ));
  }
}
