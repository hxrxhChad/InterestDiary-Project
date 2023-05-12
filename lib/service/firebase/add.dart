import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khatadiary/service/firebase/auth.dart';
import 'package:khatadiary/service/model/history-model.dart';
import 'package:khatadiary/service/model/log-model.dart';

final firestore = FirebaseFirestore.instance.collection('user').doc(authId);

Future<void> addClient(name, loan, monthly, time) async {
  Log log = Log(
      name: name,
      principal: loan,
      time: time,
      monthly: monthly,
      interest: 0,
      amount: loan,
      received: 0,
      number: '',
      clear: false,
      loan: loan,
      lastUpdated: time,
      loanTime: time,
      totalInvestment: loan);

  final clientRef = firestore.collection('client').doc(time);

  log.id = clientRef.id;
  final data = log.toMap();

  try {
    clientRef
        .set(data)
        .whenComplete(() => debugPrint('Client uploaded successfully'));
  } catch (e) {
    debugPrint('error ---> ${e.toString()}');
  }
}

Future<void> addHistory(id, amount, remarks, got, time) async {
  History history =
      History(time: time, amount: amount, remarks: remarks, got: got);

  final historyRef =
      firestore.collection('client').doc(id).collection('history').doc(time);

  history.id = historyRef.id;
  final data = history.toMap();

  try {
    historyRef
        .set(data)
        .whenComplete(() => debugPrint('History uploaded successfully'));
  } catch (e) {
    debugPrint(e.toString());
  }
}
