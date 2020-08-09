import 'package:flutter/cupertino.dart';

class Transaction {
  String id;
  //String type;
  String title;
  double amount;
  DateTime date;

  Transaction(
      {@required this.id,
      //@required this.type,
      @required this.title,
      @required this.amount,
      @required this.date});
}
