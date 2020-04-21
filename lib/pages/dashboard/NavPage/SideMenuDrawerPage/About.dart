import 'package:flutter/material.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2c3e50),
        centerTitle: true,
        title: Text('SmartPay'),
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => navigatePreviousPage(context)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: text('What is SmartPay?', TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: text('SmartPay is a cashless app innovated for institutions. It is a virtual transaction to pay for your school fees . You can also load money to your virtual wallet, pay food at canteens, transfer money to your friends and more.', TextStyle(fontSize: 16, fontWeight: FontWeight.w400))),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Image.asset('assets/SmartPayIcons/SmartPay.png', width: 250,)),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: text('Latest Update: March 2020', TextStyle(color: Color(0xFF2c3e50), fontSize: 11, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)))
          ],
        ),
      ),
    );
  }

  Widget text(txt, styleText) => Text(txt, style: styleText);

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/dashboard');
}