import 'package:flutter/material.dart';
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meu_estoque_msapp/model/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Atributos Gerais
  String _loginMsg = "Login";
  static String _url = "http://servicosflex.rpinfo.com.br:9000/v1.1/auth";
  static Map<String, String> _header = {"Content-type": "application/json"};

  //Atributos de login
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  Widget _carregando;

  //Atributos de senha
  IconData _iconSenha = Icons.visibility_off_outlined;
  bool _esconderSenha = true;

  _salvarTokenLogin(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("idUser", user.idUser);
    print("TOKEN SALVO 1: " + user.idUser);
    await prefs.setString("senhaUser", user.senhaUser);
    print("TOKEN SALVO 2: " + user.senhaUser);
    await prefs.setString("tokenUser", user.tokenUser);
    print("TOKEN SALVO 3: " + user.tokenUser);
    await prefs.setString("tokenEpx", user.tokenEpx);
    print("TOKEN SALVO 4: " + user.tokenEpx);
  }

  _validarLogin(String userId, String senha) async {
    //Codificar os dados para envio (json to String)
    var _body = json.encode({"usuario": userId, "senha": senha});
    http.Response response =
        await http.post(_url, headers: _header, body: _body);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);

    //Dados recuperados
    String _status = retorno["response"]["status"].toString();
    String _token = retorno["response"]["token"].toString();
    String _tokenExp = retorno["response"]["tokenExpiration"].toString();
    print("token: " + retorno["response"].toString());

    User _user = User();
    _user.idUser = _controllerUser.text;
    _user.senhaUser = _controllerSenha.text;
    _user.tokenUser = _token;
    _user.tokenEpx = _tokenExp;

    if (_status == "ok") {
      Timer(Duration(seconds: 1), () {
        //Passar dados do user para a Home
        Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROTA,
            arguments: _user);
        print("token: " + _user.tokenUser);
        _salvarTokenLogin(_user);
      });
    } else {
      Timer(Duration(seconds: 1), () {
        _exibirCarregando(false);
        _snackBarInfo(
            "Erro ao validar, verifique seus\ndados e tente novamente!");
      });
    }
  }

  void _snackBarInfo(String mensagem) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
      content: Text(mensagem,
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center),
      /*action: SnackBarAction(
          label: "OK", textColor: Colors.white, onPressed: () {}),*/
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _exibirCarregando(bool carregando) {
    if (carregando) {
      setState(() {
        _carregando = Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      });
    } else {
      setState(() {
        _carregando = Text(_loginMsg, style: TextStyle(fontSize: 20));
      });
    }
    return _carregando;
  }

  _exibirSenha() {
    if (_esconderSenha) {
      setState(() {
        _esconderSenha = false;
        _iconSenha = Icons.visibility_outlined;
      });
    } else {
      setState(() {
        _esconderSenha = true;
        _iconSenha = Icons.visibility_off_outlined;
      });
    }
  }

  @override
  void initState() {
    _exibirCarregando(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                width: 180,
                child: Image.asset("assets/logob.png"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 4),
                child: TextField(
                  controller: _controllerUser,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, color: Colors.pink[800]),
                  decoration: InputDecoration(
                    counterStyle: TextStyle(color: Color(0xffFF2656)),
                    hintText: "Seu usuário de 6 dígitos:",
                    hintStyle: TextStyle(fontSize: 16),
                    //Borda externa
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                        // borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 20),
                child: TextField(
                  controller: _controllerSenha,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  obscureText: _esconderSenha,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, color: Colors.pink[800]),
                  decoration: InputDecoration(
                    counterStyle: TextStyle(color: Color(0xffFF2656)),
                    hintText: "Senha de 6 dígitos:",
                    hintStyle: TextStyle(fontSize: 16),
                    suffixIcon: IconButton(
                        icon: Icon(_iconSenha),
                        onPressed: (() {
                          _exibirSenha();
                        })),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(
                        // borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: RaisedButton(
                      color: Colors.pink,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: _carregando,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        _exibirCarregando(true);
                        _validarLogin(
                            _controllerUser.text, _controllerSenha.text);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
