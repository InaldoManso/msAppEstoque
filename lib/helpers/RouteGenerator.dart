import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/telas/Home.dart';
import 'package:meu_estoque_msapp/telas/Login.dart';
import 'package:meu_estoque_msapp/telas/Logout.dart';
import 'package:meu_estoque_msapp/telas/Permissao.dart';
import 'package:meu_estoque_msapp/telas/SplashScreen.dart';

class RouteGenerator {
  static const String INICIAL_ROTA = "/";
  static const String SPLASH_ROTA = "/splash";
  static const String LOGIN_ROTA = "/login";
  static const String HOME_ROTA = "/home";
  static const String LOGOUT_ROTA = "/logout";
  static const String PERMA_ROTA = "/perma";

  //Responsável pela geração de rotas,
  //oque mantem estável a paginação de telas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Usaremos esse argumento caso se
    //faça necessário a passagem de dados entre telas
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case INICIAL_ROTA:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case LOGIN_ROTA:
        return MaterialPageRoute(builder: (_) => Login());

      case HOME_ROTA:
        return MaterialPageRoute(builder: (_) => Home(args));

      case LOGOUT_ROTA:
        return MaterialPageRoute(builder: (_) => Logout());

      case PERMA_ROTA:
        return MaterialPageRoute(builder: (_) => Permissao());

      //Se for chamada no código uma rota inválida
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada")),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
