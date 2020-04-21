import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { navigatePreviousPage(context);},
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Settings'),
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => navigatePreviousPage(context),
          )
        ),
        body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 120),
                child: title('Account Information'),
              ),
              Divider(color: Colors.grey[300]),
              listTile(Image.asset('assets/SmartPayIcons/Profile.png'), 'Profile', () => navigatePage('/editProfile'), Icons.arrow_forward_ios),
              Padding(
                padding: const EdgeInsets.only(top: 80, right: 250),
                child: title('About Us'),
              ),
              Divider(color: Colors.grey[300]),
              listTile(Image.asset('assets/SmartPayIcons/Terms-Conditions.png'), 'Terms and Conditions', null, Icons.arrow_forward_ios),
              Padding(padding: const EdgeInsets.only(top: 30)),
              listTile(Image.asset('assets/SmartPayIcons/About.png'), 'About SmartPay', null , Icons.arrow_forward_ios),
              Padding(
                padding: const EdgeInsets.only(top: 270),
                child: title('SmartPay'),
              ),
            ],
          )
          )
    );
  }

  Widget title(txt) => Text(txt, style: TextStyle(color: Colors.grey[300], fontSize: 20, fontWeight: FontWeight.w500));
  
  Widget listTile(prefixIcon, txt, goTo, suffixIcon) => ListTile(
    title: Text(txt, style: TextStyle(color: Colors.white),),
    onTap: goTo,
    leading: IconButton(icon: prefixIcon, onPressed: null),
    trailing: Icon(suffixIcon, color: Colors.grey[300],),
  );

  void navigatePage(navTo) =>
		Navigator.pushReplacementNamed(context, navTo);

  void navigatePreviousPage(context) => Navigator.pushReplacementNamed(context, '/dashboard');
}