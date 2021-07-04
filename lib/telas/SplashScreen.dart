import 'dart:async';
import 'package:meu_estoque_msapp/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _recuperarTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenValidar = prefs.getString("tokenUser") ?? "null";

    if (tokenValidar != "null") {
      User user = User();
      user.idUser = prefs.getString("idUser");
      user.senhaUser = prefs.getString("senhaUser");
      user.tokenUser = prefs.getString("tokenUser");
      user.idUser = prefs.getString("idUser");
      _delayHome(user);
    } else {
      _delayScreen();
    }

    print("TOKEN SALVO REC: " + tokenValidar);
  }

  //Delay de abertura
  _delayScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROTA);
    });
  }

  _delayHome(User user) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROTA, arguments: user );
    });
  }

  @override
  void initState() {
    _recuperarTokenLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xffFF2656)),
      child: Center(
        child: Image.asset("assets/logoa.png", width: 200, height: 200),
      ),
    );
  }
}
