import 'dart:convert';

class Abono {
  int codigo;
  String motivo;
  String anexo;
  String dataSolicitacao;
  String dataAbonada;
  String nome;
  int codEmpregado;
  bool aprovado;
  String avaliacao;


  Abono({this.codigo,
      this.motivo,
      this.anexo,
      this.dataSolicitacao,
      this.dataAbonada,
      this.codEmpregado,
      this.nome,
      this.aprovado,
      this.avaliacao});

  factory Abono.fromJson(Map<String, dynamic> map) {
    return Abono(
      codigo: map["codigo"],
      motivo: map["motivo"],
      anexo: map["anexo"],
      dataSolicitacao: map["data_solicitacao"],
      dataAbonada: map["data_abonada"],
      codEmpregado: map["cod_empregado"],
      nome: map["nome"],
      aprovado: map["aprovado"],
      avaliacao: map["avaliacao"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "motivo": motivo,
      "anexo": anexo,
      "data_solicitacao": dataSolicitacao,
      "data_abonada": dataAbonada,
      "cod_empregado": codEmpregado,
      "nome": nome,
      "aprovado": aprovado,
      "avaliacao": avaliacao
    };
  }

  @override
  String toString() {
    return 'Abono {codigo: $codigo, motivo: $motivo, anexo: $anexo' +
        'data_solicitacao: $dataSolicitacao, data_abonada: $dataAbonada, cod_empregado: $codEmpregado,' +
        'nome: $nome, aprovado: $aprovado, avaliacao: $avaliacao}';
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
