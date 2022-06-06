import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transactions_list.dart';
import './widgets/chart.dart';

import './models/transactions.dart';

void main() {
  // SystemChrome.setPreferredOrientations(  // to control the orientation of the  screen that it can't have a landscape mode.
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //String titleInput;
  final List<Transaction> _transactionsList = [
    //   Transaction(
    //     id: '1',
    //     title: 'New book',
    //     price: 30,
    //     date: DateTime.now(),
    //   ),
    //   Transaction(
    //     id: '2',
    //     title: 'Crepe',
    //     price: 25,
    //     date: DateTime.now(),
    //   ),
  ];

  List<Transaction> get _recentTransaction {
    return _transactionsList.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txPrice, DateTime chosenDate) {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        price: txPrice,
        date: chosenDate);

    setState(() {
      _transactionsList.add(newTX);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTx(String id) {
    setState(() {
      _transactionsList.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;
//.................TO PRINT THE APP LIFE CYCLE..................................
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//------------------------------------------------------------------------------ IF WE ARE IN 'LANDSCAPE' MODE.
  List<Widget> _landScapeModeBuilder(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Charts?',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch(
              value: _showChart,
              onChanged: (newValue) {
                setState(() {
                  _showChart = newValue;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              //------------------------------------------------------ THE CHART CONTAINER
              height: (mediaQuery
                          .size //--------------------------------------> MediaQuery uses to control the widgets sizes on all of the screen.
                          .height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .7,
              child: Chart(_recentTransaction))
          : txListWidget
    ];
  }

//------------------------------------------------------------------------------ IF WE ARE IN PORTRAIT MODE.
  List<Widget> _portraitModeBuilder(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .3,
        child: Chart(_recentTransaction),
      ),
      txListWidget
    ];
  }

//------------------------------------------------------------------------------ APP_BAR BUILDER.
  PreferredSizeWidget _appBarBuilder() {
    return AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add_outlined),
            onPressed: () => _startAddNewTransaction(context)),
      ],
    );
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    final txListWidget = Container(
        // THE LIST CONTAINER
        height: (mediaQuery.size.height -
                _appBarBuilder().preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: TransactionsList(_transactionsList, _deleteTx));
    return Scaffold(
      appBar: _appBarBuilder(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandScape)
                ..._landScapeModeBuilder(mediaQuery, _appBarBuilder(),
                    txListWidget), //----> (...) is called "spread opreator" and it get elements of a list and spreading them in a new list.
              if (!isLandScape)
                ..._portraitModeBuilder(
                    mediaQuery, _appBarBuilder(), txListWidget),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_outlined),
          onPressed: () => _startAddNewTransaction(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
