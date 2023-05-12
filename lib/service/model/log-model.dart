// ignore_for_file: file_names

import 'dart:convert';

Log logFromMap(String str) => Log.fromMap(json.decode(str));

String logToMap(Log data) => json.encode(data.toMap());

class Log {
  String? id;
  final String name;
  final String number;
  final double principal;
  final double totalInvestment;
  final double loan;
  final String lastUpdated;
  final String time;
  final String loanTime;
  final bool monthly;
  final double interest;
  final double amount;
  final double received;
  final bool clear;

  Log({
    this.id,
    required this.name,
    required this.number,
    required this.clear,
    required this.principal,
    required this.totalInvestment,
    required this.loan,
    required this.lastUpdated,
    required this.time,
    required this.loanTime,
    required this.monthly,
    required this.interest,
    required this.amount,
    required this.received,
  });

  factory Log.fromMap(Map<String, dynamic> json) => Log(
        id: json["id"],
        name: json["name"],
        number: json["number"],
        clear: json["clear"],
        principal: json["principal"],
        totalInvestment: json["totalInvestment"],
        loan: json["loan"],
        lastUpdated: json["lastUpdated"],
        time: json["time"],
        loanTime: json["loanTime"],
        monthly: json["monthly"],
        interest: json["interest"],
        amount: json["amount"],
        received: json["received"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "principal": principal,
        "totalInvestment": totalInvestment,
        "loan": loan,
        "lastUpdated": lastUpdated,
        "number": number,
        "clear": clear,
        "time": time,
        "loanTime": loanTime,
        "monthly": monthly,
        "interest": interest,
        "amount": amount,
        "received": received,
      };
}

// loaned money - lastUpdated
