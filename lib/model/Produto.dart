class Produto {
  var codigo;
  var descricao;
  var preco;
  var codigoBarras;

  //Construtor
  Produto({this.codigo, this.descricao, this.preco, this.codigoBarras});

  //Construtor que recebe map e trataremos como json
  //Este método instancia um único Produto que é retornado a cada item
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      codigo: json["Codigo"],
      descricao: json["Descricao"],
      preco: json["Preco"],
      codigoBarras: json["CodigoBarras"],
    );
  }
}
