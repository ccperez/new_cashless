import 'package:flutter/material.dart';

class TransferMoneyDetails extends StatefulWidget {
  TransferMoneyDetails({Key key}) : super(key: key);

  @override
  _TransferMoneyDetailsState createState() => _TransferMoneyDetailsState();
}

class _TransferMoneyDetailsState extends State<TransferMoneyDetails> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){ navigatePreviousPage(context); },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2c3e50),
          title: Text('Confirmation'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          ),
        ),
      body: ListView(
        children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 170, left: 30, right: 30),
                alignment: Alignment.topLeft,
                child: text('Phone Number of money transfered')
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.topLeft,
                child: text('Transfer Amount: '),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.topLeft,
                child: text('Message: '),
              ),
              transferButton('Transfer')
            ],
          ),
      )
    );
  }

  Widget text(txt) => Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Text(txt, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500))
  );

  Widget transferButton(buttonText) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
      child: ButtonTheme(
        minWidth: 400,
        height: 50,
        child: RaisedButton(
          elevation: 5,
          color: Colors.green,
          child: Text(buttonText, style: TextStyle(color: Colors.white, fontSize: 18),),
          onPressed: () => dialog(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    ),
  );
  }

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/transferMoney');

  dialog() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('TRANSFER MONEY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text('CONFIRMATION', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          Text(
            'To proceed with your request, please enter your pin:',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)
					),
        ],
      ),
			content: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter pin for payment',
          hintStyle: TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            tooltip: 'Forgot Pin?',
              icon: Text('?', style: TextStyle(color: Colors.blue)),
              onPressed: () {},
            ),
          )
        ),
      actions: <Widget>[
            FlatButton(
            onPressed: () {},
            child: Text('Submit')
          )
      ]
      ),
  );
}
