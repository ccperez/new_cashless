import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  Transaction({Key key}) : super(key: key);

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10),
           child: ListView(
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(top: 30),
                 child: Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
               ),
               Padding(padding: const EdgeInsets.only(top: 20)),
               card('Purchased from:', '10 mins ago', '₱ 100.00'),
               card('Purchased from:', '20 mins ago', '₱ 200.00'),
               card('Purchased from:', '30 mins ago', '₱ 300.00'),
               card('Purchased from:', '40 mins ago', '₱ 400.00'),
               card('Purchased from:', '50 mins ago', '₱ 500.00'),
               card('Purchased from:', '1 hr ago', '₱ 600.00'),
               card('Purchased from:', '2 hrs ago', '₱ 700.00'),
               card('Purchased from:', '3 hrs ago', '₱ 800.00'),
               card('Purchased from:', '4 hrs ago', '₱ 900.00'),
             ],
           ),
         )
       );
  }

  Widget card(txt, txtTime, txtPrice) => Card(
    elevation: 5,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(txt, style: TextStyle(color: Colors.grey[700]),),
              Text(txtTime, style: TextStyle(color: Colors.grey[700]),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Shop', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Text(txtPrice, style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.w500)),
            ],
            ),
        )
      ],
    ),
  );
}