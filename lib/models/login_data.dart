class LoginData {
  int id;
  String nominativo;
  String immagine;
  String token;
  String contatto;

  LoginData(
      {this.id, this.nominativo, this.immagine, this.token, this.contatto});

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nominativo = json['nominativo'];
    immagine = json['immagine'];
    token = json['token'];
    contatto = json['contatto'];
  }
}
