import 'package:flutter/material.dart';
import '../models/transactions.dart';
import './transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function deleteTx;

  TransactionsList(this.transactionList, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return transactionList.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              // IF THERE IS NOT A TRANSACTION.
              children: [
                Text(
                  'There is no transactions yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: constraints.maxHeight * .6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactionList
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      mediaQuery: mediaQuery,
                      deleteTx: deleteTx,
                      transaction: tx,
                    ))
                .toList(),
          );
  }
}
