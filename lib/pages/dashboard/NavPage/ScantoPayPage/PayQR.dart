import 'package:flutter/material.dart';

class PayQR extends StatefulWidget {
  PayQR({Key key}) : super(key: key);

  @override
  _PayQRState createState() => _PayQRState();
}

class _PayQRState extends State<PayQR> {

   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context);},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Pay QR'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
      ),
    );
  }

  
   void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);
  
   void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/scantoPay');
}
