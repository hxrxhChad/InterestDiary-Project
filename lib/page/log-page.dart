// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khatadiary/page/history-page.dart';
import 'package:khatadiary/widget/function/navigator.dart';
import 'package:khatadiary/widget/home/log-tile.dart';

import '../service/firebase/add.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection('client')
            .orderBy('id', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? const SizedBox(
                  height: 0,
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data();
                    DateTime nTime = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(data['time']));
                    String date = DateFormat('dd MMMM, yyyy').format(nTime);
                    return InkWell(
                      onTap: () => push(
                          context,
                          HistoryPage(
                            id: data['id'],
                            name: data['name'],
                          )),
                      child: LogTile(
                        name: data['name'],
                        left: data['amount'],
                        given: data['totalInvestment'],
                        got: data['received'],
                        date: date,
                        avatar: '',
                        monthly: data['monthly'],
                        clear: data['clear'],
                      ),
                    );
                  });
        });
  }
}
