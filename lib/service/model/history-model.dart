// ignore_for_file: file_names

import 'dart:convert';

History historyFromMap(String str) => History.fromMap(json.decode(str));

String historyToMap(History data) => json.encode(data.toMap());

class History {
  String? id;
  final String time;
  final double amount;
  final String remarks;
  final bool got;

  History({
    this.id,
    required this.time,
    required this.amount,
    required this.remarks,
    required this.got,
  });

  factory History.fromMap(Map<String, dynamic> json) => History(
        id: json["id"],
        time: json["time"],
        amount: json["amount"],
        remarks: json["remarks"],
        got: json["got"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time,
        "amount": amount,
        "remarks": remarks,
        "got": got,
      };
}
