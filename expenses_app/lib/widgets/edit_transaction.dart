import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransaction extends StatefulWidget {
  //variables
  final Function editTx;
  final List<Transaction> transactions;

  final id;

  //functions
  EditTransaction(this.editTx, this.transactions, this.id);

  @override
  _EditTrasactionState createState() => _EditTrasactionState();
}

class _EditTrasactionState extends State<EditTransaction> {
  //variables
  Transaction originalTx;
  TextEditingController _titleController;
  TextEditingController _amountController;
  static DateTime _selectedDate;

  //functions
  void getTransaction() {
    for (var Tx in widget.transactions) {
      if (Tx.id == widget.id) {
        originalTx = Tx;
        break;
      }
    }
  }

  void _editData(String id) {
    final editedTitle = _titleController.text;
    final editedAmount = double.parse(_amountController.text);
    final editedDate = _selectedDate;

    if (editedTitle.isEmpty ||
        editedAmount <= 0 ||
        (editedTitle == originalTx.title &&
            editedAmount == originalTx.amount &&
            editedDate == originalTx.date)) {
      return;
    }
    widget.editTx(
      id,
      editedTitle,
      editedAmount,
      editedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null || pickedDate == DateTime.now()) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTransaction();
    _selectedDate = originalTx.date;
    _titleController = new TextEditingController(text: '${originalTx.title}');
    _amountController = new TextEditingController(text: '${originalTx.amount}');
  }

  //widget
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
              ),
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
              ),
              controller: _titleController,
              onSubmitted: (_) => _editData(widget.id),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _editData(widget.id),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    "Change Date",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(top: 40),
              child: new SizedBox(
                width: 185.0,
                height: 40.0,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.purple,
                  onPressed: () => _editData(widget.id),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.5)),
                  child: Text(
                    "Update Transaction",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
