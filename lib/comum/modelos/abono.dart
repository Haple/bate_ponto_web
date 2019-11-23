import 'dart:convert';

class Abono {
  int codigo;
  String motivo;
  String anexo;
  String data_solicitacao;
  String data_abonada;
  int cod_empregado;

  Abono({this.codigo,
      this.motivo,
      this.anexo,
      this.data_solicitacao,
      this.data_abonada,
      this.cod_empregado});

  factory Abono.fromJson(Map<String, dynamic> map) {
    return Abono(
      codigo: map["codigo"],
      motivo: map["motivo"],
      anexo: map["anexo"],
      data_solicitacao: map["data_solicitacao"],
      data_abonada: map["data_abonada"],
      cod_empregado: map["cod_empregado"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "motivo": motivo,
      "anexo": anexo,
      "data_solicitacao": data_solicitacao,
      "data_abonada": data_abonada,
      "cod_empregado": cod_empregado
    };
  }

  @override
  String toString() {
    return 'Abono {codigo: $codigo, motivo: $motivo, anexo: $anexo' +
        'data_solicitacao: $data_solicitacao, data_abonada: $data_abonada, cod_empregado: $cod_empregado}';
  }
}

List<Abono> abonosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Abono>.from(data.map((item) => Abono.fromJson(item)));
}

String abonoToJson(Abono data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
