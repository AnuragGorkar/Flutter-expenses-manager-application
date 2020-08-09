import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'edit_transaction.dart';

class TransactionList extends StatefulWidget {
  //variables
  final List<Transaction> transactions;
  final Function deleteTransaction;
  final Function editTransaction;

  //functions
  TransactionList(@required this.transactions, @required this.deleteTransaction,
      @required this.editTransaction);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
//functions

  void _startEditTransaction(String id, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: EditTransaction(
                widget.editTransaction, widget.transactions, id),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  showAlertDialog(String txID, BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      ),
      onPressed: () {
        widget.deleteTransaction(txID);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Transaction",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("Do you want to delete this transaction ? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return widget.transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Opacity(
              opacity: 0.3,
              child: Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet !!!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.10,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover),
                  ),
                ],
              ),
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                elevation: 5,
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            '${widget.transactions[index].amount} ₹',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(widget.transactions[index].date),
                      style: TextStyle(
                        fontFamily: "Quicksand",
                      ),
                    ),
                    trailing: mediaQuery.size.width > 400
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FlatButton.icon(
                                onPressed: () => _startEditTransaction(
                                    widget.transactions[index].id, context),
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).accentColor,
                                ),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: () => showAlertDialog(
                                      widget.transactions[index].id, context),
                                  icon: Icon(Icons.delete,
                                      color: Theme.of(context).errorColor),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).errorColor,
                                    ),
                                  )),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Theme.of(context).accentColor,
                                onPressed: () => _startEditTransaction(
                                    widget.transactions[index].id, context),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Theme.of(context).errorColor,
                                onPressed: () => showAlertDialog(
                                    widget.transactions[index].id, context),
                              ),
                            ],
                          )),
              );
            },
            itemCount: widget.transactions.length,
          );
  }
}
