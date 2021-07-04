import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';
import 'package:meu_estoque_msapp/telas/SplashScreen.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
        primaryColor: Color(0xffFF2656), accentColor: Colors.pinkAccent),
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
