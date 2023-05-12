import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khatadiary/common/style.dart';
import 'package:khatadiary/service/firebase/add.dart';

import '../widget/home/interest-box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double invest = 0;
  double returns = 0;

  Future<void> getInvestment() async {
    var querySnapshot = await firestore.collection('client').get();

    double sum1 = 0;

    for (var doc in querySnapshot.docs) {
      if (doc.data().containsKey('totalInvestment')) {
        sum1 += doc.data()['totalInvestment'];
      }
    }

    setState(() {
      invest = sum1;
    });
  }

  Future<void> getReturns() async {
    var querySnapshot = await firestore.collection('client').get();

    double sum2 = 0;

    for (var doc in querySnapshot.docs) {
      if (doc.data().containsKey('received')) {
        sum2 += doc.data()['received'];
      }
    }

    setState(() {
      returns = sum2;
    });
  }

  @override
  initState() {
    super.initState();
    getInvestment();
    getReturns();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: kPad(context) * 0.1,
                horizontal: kPad(context) * 0.08),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              shadowColor: returns - invest < 0
                  ? Colors.red.withOpacity(0.4)
                  : primaryColor(context).withOpacity(0.5),
              child: Container(
                height: kPad(context) * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: returns - invest < 0
                            ? [Colors.red.withOpacity(0.7), Colors.red]
                            : [primaryColor(context), Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(kPad(context) * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total ${returns - invest < 0 ? 'Loss' : 'Profit '}',
                          style: style(context).copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: kPad(context) * 0.04,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: kPad(context) * 0.01,
                        ),
                        Text(
                          '₹ ${returns - invest < 0 ? invest - returns : returns - invest}',
                          style: style(context).copyWith(
                              color: Colors.white,
                              fontSize: kPad(context) * 0.1,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: firestore
                            .collection('client')
                            .orderBy('loanTime', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const SizedBox(
                              height: 0,
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 0,
                            );
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs.first.data();
                            DateTime nTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(data['loanTime']));
                            String date =
                                DateFormat('dd MMMM, yyyy').format(nTime);

                            return Text(
                              'Last Given : ${data['name']} on $date',
                              style: style(context).copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: kPad(context) * 0.035,
                                  fontWeight: FontWeight.w500),
                            );
                          }
                          return const SizedBox(
                            height: 0,
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPad(context) * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InterestBox(
                  text: 'Invested',
                  money: invest,
                  icon: CupertinoIcons.up_arrow,
                  color: Colors.deepOrange,
                ),
                InterestBox(
                  text: 'Returns',
                  money: returns,
                  icon: CupertinoIcons.down_arrow,
                  color: Colors.green,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
