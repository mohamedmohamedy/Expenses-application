import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.mediaQuery,
    @required this.deleteTx,
    @required this.transaction,
  }) : super(key: key);

  final MediaQueryData mediaQuery;
  final Function deleteTx;
  final Transaction transaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  //.................CHANGING THE CIRCLE AVATAR COLOR..........................

  Color _bgColor;

  @override
  void initState() {
    super.initState();

    const availableColors = [
      Colors.blue,
      Colors.deepOrange,
      Colors.tealAccent,
      Colors.lightGreenAccent,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
  }

//..............................................................................

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        trailing: widget.mediaQuery.size.width > 500
            ? FlatButton.icon(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
              )
            : (IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )),
        subtitle: Text(
          DateFormat.yMMMMd().format(widget.transaction.date),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(child: Text('\$${widget.transaction.price}')),
          ),
        ),
      ),
    );
  }
}
