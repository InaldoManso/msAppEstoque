class User {
  String _idUser;
  String _senhaUser;
  String _tokenUser;
  String _tokenEpx;

  User();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "usuario": this.idUser,
      "senha": this.senhaUser,
      "token": this.tokenUser,
      "tokenExpiration": this.tokenEpx,
    };
    return map;
  }

  get idUser => this._idUser;

  set idUser(value) => this._idUser = value;

  get senhaUser => this._senhaUser;

  set senhaUser(value) => this._senhaUser = value;

  get tokenUser => this._tokenUser;

  set tokenUser(value) => this._tokenUser = value;

  get tokenEpx => this._tokenEpx;

  set tokenEpx(value) => this._tokenEpx = value;
}
