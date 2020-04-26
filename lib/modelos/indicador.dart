import 'dart:convert';

import 'resultado_indicador.dart';

class Indicador {
  int codigoIndicador;
  bool ativado;
  String titulo;
  String mensagem;
  List<ResultadoIndicador> resultados;

  Indicador({
    this.codigoIndicador,
    this.ativado,
    this.titulo,
    this.mensagem,
    this.resultados,
  });

  factory Indicador.fromJson(Map<String, dynamic> map) {
    var resultados = new List<ResultadoIndicador>();
    map['resultados'].forEach((v) {
      resultados.add(new ResultadoIndicador.fromJson(v));
    });

    return Indicador(
      codigoIndicador: map["codigo"],
      ativado: map["ativado"],
      titulo: map["titulo"],
      mensagem: map["mensagem"],
      resultados: resultados
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigoIndicador": codigoIndicador,
      "ativado": ativado,
      "titulo": titulo,
      "mensagem": mensagem,
      "resultados": resultados,
    };
  }

  @override
  String toString() {
    return indicadorToJson(this);
  }
}

List<Indicador> indicadoresFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Indicador>.from(data.map((item) => Indicador.fromJson(item)));
}

String indicadorToJson(Indicador data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
