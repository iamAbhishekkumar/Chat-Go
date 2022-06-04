import 'package:ChatGo/pages/home.dart';
import 'package:ChatGo/pages/register.dart';
import 'package:ChatGo/pages/signIn.dart';
import 'package:ChatGo/services/saveData.dart';
import 'package:flutter/material.dart';

class Handler extends StatefulWidget {
  @override
  _HandlerState createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {
  bool isLoggedIn;
  @override
  void initState() {
    getLoginState();
    super.initState();
  }

  getLoginState() async {
    await SaveData.getUserLoggedInPreferences().then((val) {
      setState(() {
        isLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn != null ? (isLoggedIn ? Home() : SignIn()) : Register();
  }
}
