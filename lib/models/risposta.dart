class Risposta {
  String contatto;
  String messaggio;

  Risposta({this.contatto, this.messaggio});

  Risposta.fromJson(Map<String, dynamic> json) {
    contatto = json['contatto'];
    messaggio = json['messaggio'];
  }

  Risposta.toJson(Map<String, dynamic> json) {
    contatto = json['contatto'];
    messaggio = json['messaggio'];
  }
}
