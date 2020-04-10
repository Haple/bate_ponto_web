import 'dart:convert';

class Atraso {
  int codigoAtraso;
  int codigoEmpregado;
  String nome;
  String email;
  String dataHoraAtraso;
  List<String> jornada;

  Atraso({
    this.codigoAtraso,
    this.codigoEmpregado,
    this.nome,
    this.email,
    this.dataHoraAtraso,
    this.jornada,
  });

  factory Atraso.fromJson(Map<String, dynamic> map) {
    return Atraso(
      codigoAtraso: int.parse(map["codigo_atraso"]),
      codigoEmpregado: map["codigo_empregado"],
      nome: map["nome"],
      email: map["email"],
      dataHoraAtraso: map["data_hora_atraso"],
      jornada: List.from(map["jornada"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo_atraso": codigoAtraso,
      "codigo_empregado": codigoEmpregado,
      "nome": nome,
      "email": email,
      "data_hora_atraso": dataHoraAtraso,
      "jornada": jornada,
    };
  }

  @override
  String toString() {
    return atrasoToJson(this);
  }
}

List<Atraso> atrasosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Atraso>.from(data.map((item) => Atraso.fromJson(item)));
}

String atrasoToJson(Atraso data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
