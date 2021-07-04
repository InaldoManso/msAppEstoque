import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:meu_estoque_msapp/helpers/RouteGenerator.dart';
import 'package:meu_estoque_msapp/model/Produto.dart';
import 'dart:convert';
import 'package:meu_estoque_msapp/model/User.dart';

class Home extends StatefulWidget {
  //resgate dos argumentos de Login
  User user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Atributos Gerais
  static String _url =
      "http://servicosflex.rpinfo.com.br:9000/v2.0/produtounidade/listaprodutos/0/unidade/83402711000110";
  static String _urlLogof =
      "http://servicosflex.rpinfo.com.br:9000/v1.1/logout";
  static Map<String, String> _header = {"Content-type": "application/json"};

  Future<List<Produto>> _recuperarProdutos() async {
    //Recuperar produtos da API
    Map<String, String> _header = {"token": widget.user.tokenUser};
    http.Response response = await http.get(_url, headers: _header);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);

    //Listagem dos produtos, percorrendo o MAP de produtos
    List<Produto> produtos = retorno["response"]["produtos"].map<Produto>(
      //Converter o map para um Produto
      (map) {
        return Produto.fromJson(map);
      },
    ).toList(); //Para listarmos todos os produtos

    return produtos;
  }

  _logof(String userId) async {
    //Codificar os dados para envio (json to String)
    Map<String, String> header = {
      "Content-type": "application/json",
      "token": widget.user.tokenUser
    };
    http.Response response = await http.get(_urlLogof, headers: header);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);

    //Dados recuperados
    String _status = retorno["response"]["status"].toString();
    print("XXXXX " + _status);

    if (_status == "ok") {
      //Passar dados do user para a Home
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGOUT_ROTA);
    } else {
      _snackBarInfo("Erro no logof, verifique sua conexão ou reinicie o app.");
    }
  }

  Widget _exibirErro() {
    Timer(Duration(microseconds: 1), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.PERMA_ROTA);
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  //Informação do Snackbar
  void _snackBarInfo(String aviso) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      backgroundColor: Colors.lightBlue,
      content: Text(
        aviso,
        style: TextStyle(fontSize: 16, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _recuperarProdutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _atualizarExibir() {
      FutureBuilder futureBuilder;

      setState(() {
        futureBuilder = FutureBuilder<List<Produto>>(
          future: _recuperarProdutos(),
          builder: (context, snaphot) {
            switch (snaphot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                //Verificar se existem produtos a exibir
                if (snaphot.hasData) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        //Recuperar a lista
                        List<Produto> produtos = snaphot.data;
                        Produto produto = produtos[index];
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      produto.descricao,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Text(
                                    "Toque para copiar",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey[700],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Cod. Produto: "),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        produto.codigo.toString(),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: produto.codigo.toString()));
                                        _snackBarInfo("Código copiado!");
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Preço:"),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        "R\$: " + produto.preco.toString(),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.blue),
                                      ),
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: produto.preco.toString()));
                                        _snackBarInfo("Preço copiado!");
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[700],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Cod. barras",
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      produto.codigoBarras,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.blue),
                                    ),
                                    onTap: () {
                                      Clipboard.setData(new ClipboardData(
                                          text:
                                              produto.codigoBarras.toString()));
                                      _snackBarInfo(
                                          "Código de barras copiado!");
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.pink[400],
                          ),
                      itemCount: snaphot.data.length);
                } else {
                  return _exibirErro();
                }
                break;
            }
            return null;
          },
        );
      });

      return futureBuilder;
    }

    return Scaffold(
      body: Container(
        color: Colors.pinkAccent[100],
        child: _atualizarExibir(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Color(0xffFF2656),
                borderRadius: BorderRadius.circular(32)),
            child: IconButton(
              // Icone
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                _logof(widget.user.tokenUser);
              },
            ),
          ),
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(32)),
            child: IconButton(
              icon: Icon(Icons.refresh_outlined, color: Colors.white),
              onPressed: () {
                _atualizarExibir();
              },
            ),
          ),
        ],
      ),
    );
  }
}
