import 'package:flutter/material.dart';

class ScantoPay extends StatefulWidget {
  ScantoPay({Key key}) : super(key: key);

  @override
  _ScantoPayState createState() => _ScantoPayState();
}

class _ScantoPayState extends State<ScantoPay> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context);},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Scan To Pay'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
      ),
    );
  }
   void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/');
}
