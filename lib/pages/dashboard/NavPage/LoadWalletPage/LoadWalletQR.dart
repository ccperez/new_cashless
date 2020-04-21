import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoadWalletQR extends StatefulWidget {
	final load;
	final lstType;

  LoadWalletQR(this.load, this.lstType);

  @override
  _LoadWalletQRState createState() => _LoadWalletQRState(this.load, this.lstType);
}

class _LoadWalletQRState extends State<LoadWalletQR> {
	final load;
	final lstType;

	_LoadWalletQRState(this.load, this.lstType);

	_loadType(t) => lstType[t];

	_loadData(ld) => ld['phone']+'|'+(ld['type']+1).toString()+'|'+ld['amount'].toString();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePage('/loadWallet'); },
      child: Scaffold(
        backgroundColor: Color(0xFF2c3e50),
        appBar: AppBar(
          elevation: 0,
          title: Text("QR Code"),
          backgroundColor: Color(0xFF2c3e50),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePage('/loadWallet')),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => dialog()
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF16a085), Color(0xFF00cc88)]),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    textInstructions(
											'Scan QR to Load Wallet',
											TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
										),
										textInstructions(
											'Amount : '+load['amount'].toString()+'  Type : ' + _loadType(load['type']),
											TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)
										),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 70, right: 70),
                      child: QrImage(data: _loadData(load), version: QrVersions.auto, size: 800.0),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget textInstructions(txt, txtStyle) => Padding(
    padding: const EdgeInsets.only(left: 50, right: 50, top: 60),
    child: Text(txt, style: txtStyle),
  );

  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

  dialog() => showDialog(
    context: context, builder: (BuildContext context) => AlertDialog(
      title: Text('Are you done using the QR code?', style: TextStyle( fontSize: 18, fontStyle: FontStyle.italic)),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () =>  Navigator.pop(context, true)
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () => navigatePage('/')
        )
      ],
    )
  );
}


