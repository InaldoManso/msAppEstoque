import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  _removerTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("idUser");
    await prefs.remove("senhaUser");
    await prefs.remove("tokenUser");
    await prefs.remove("tokenEpx");

    _delayScreen();
  }

  _delayScreen() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROTA);
    });
  }

  @override
  void initState() {
    _removerTokenLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFF2656),
      body: Center(
        child: Text(
          "Até breve!",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
