import 'package:flutter/material.dart';

class ReceiveMoney extends StatefulWidget {
  ReceiveMoney({Key key}) : super(key: key);

  @override
  _ReceiveMoneyState createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){ navigatePreviousPage(context);},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Receive Money'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
      ),
    );
  }

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/');
}
