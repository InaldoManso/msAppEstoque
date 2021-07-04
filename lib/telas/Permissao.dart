import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Permissao extends StatefulWidget {
  @override
  _PermissaoState createState() => _PermissaoState();
}

class _PermissaoState extends State<Permissao> {
  _removerTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("idUser");
    await prefs.remove("senhaUser");
    await prefs.remove("tokenUser");
    await prefs.remove("tokenEpx");

    _delayScreen();
  }

  _delayScreen() {
    Timer(Duration(seconds: 6), () {
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
          "Sua permissão de acesso ja\n não esta mais válida, por gentileza\nrealize o login novamente!",
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
