import 'package:flutter/material.dart';
import 'package:khatadiary/service/firebase/add.dart';

// to update during history input

Future<void> updateLog(
  id,
  principal,
  totalInvestment,
  amount,
  received,
  time,
) async {
  await firestore.collection('client').doc(id).update({
    "principal": principal,
    "totalInvestment": totalInvestment,
    "amount": amount,
    "received": received,
    "time": time,
  }).whenComplete(() {
    debugPrint('--- updated ----');
  });
}

// to update daily
Future<void> updateDaily(
  id,
  amount,
  interest,
  lastUpdated,
) async {
  await firestore.collection('client').doc(id).update({
    "amount": amount,
    "interest": interest,
    "lastUpdated": lastUpdated,
  }).whenComplete(() {
    debugPrint('--- updated ----');
  });
}
