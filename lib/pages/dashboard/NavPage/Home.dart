import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _phone;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userInfo = json.decode(preferences.getString("user"));
		setState(() { _phone = userInfo["phone"]; });
  }

  @override
	void initState() {
		super.initState();
		getPref();
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: Color(0xFF2c3e50)
                  ),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              card('Current Balance', TextStyle(color: Colors.white, fontSize: 16)),
                              card('PHP', TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                       ),

                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Table(
                            border: TableBorder.all(color: Colors.black26, width: 1, style: BorderStyle.none),
                            children: [
                              TableRow(children: [
                                TableCell(child: Text('Allowance')),
                                TableCell(child: Text(': ₱')),
                                TableCell(child: Text('123,456'))
                              ]),
                              TableRow(children: [
                                TableCell(child: Text('Tuition')),
                                TableCell(child: Text(': ₱')),
                                TableCell(child: Text('123,456'))
                              ]),
                            ],
                          ),
                        ),

                        Container(
                          child: Row(
                            children: <Widget>[
                              Padding(
                               padding: const EdgeInsets.only(top: 30, left: 30),
                                child: card(securePhone(_phone), TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 130, top: 10),
                                child: loadIcon(Icons.add),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color(0xFF16a085), Color(0xFF00cc88)]
                    )
                  ),
                ),
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 30),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconButton(
                  icon: Image.asset('assets/FunctionIcons/ScantoPay.png'),
                  onPressed: null,
                  iconSize: 80),
                onTap: () => navigatePage('/scantoPay'),
                title: Text('Scan to Pay', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconButton(
                  icon: Image.asset('assets/FunctionIcons/TransferMoney.png'),
                  onPressed: null,
                  iconSize: 80),
                onTap: () => navigatePage('/transferMoney'),
                title: Text('Transfer Money', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconButton(
                  icon: Image.asset('assets/FunctionIcons/ReceiveMoney.png'),
                  onPressed: null,
                  iconSize: 80),
                onTap: () => navigatePage('/receiveMoney'),
                title: Text('Receive Money', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          )
          ]
        ),
      ),
    );
  }

  Widget card(txt, styleText) => Text(txt, style: styleText);

  Widget loadIcon(iconBtn) => FloatingActionButton(
    tooltip: 'Load Wallet',
    elevation: 0,
    backgroundColor: Color(0xFF006644),
    child: Icon(iconBtn),
    onPressed: () => navigatePage('/loadWallet'),
  );

  Widget iconBtn(iconTxt) => Card(
    child: ListTile(
      title: iconTxt,
    ),
  );


  void navigatePage(navTo) => Navigator.pushReplacementNamed(context, navTo);

	securePhone(phone) => phone == null ? "" : phone.replaceRange(4, 9, '*' * 5);

}


  




