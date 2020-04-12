import 'dart:convert';

class ResultadoIndicador {

  int mes;
  int concordo;
  int neutro;
  int discordo;

  ResultadoIndicador({
    this.mes,
    this.concordo,
    this.neutro,
    this.discordo,
  });

  factory ResultadoIndicador.fromJson(Map<String, dynamic> map) {
    return ResultadoIndicador(
      mes: map["mes"],
      concordo: map["concordo"],
      neutro: map["neutro"],
      discordo: map["discordo"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mes": mes,
      "concordo": concordo,
      "neutro": neutro,
      "discordo": discordo,
    };
  }

  @override
  String toString() {
    return resultadoIndicadorToJson(this);
  }
}

List<ResultadoIndicador> resultadosIndicadorFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ResultadoIndicador>.from(data.map((item) => ResultadoIndicador.fromJson(item)));
}

String resultadoIndicadorToJson(ResultadoIndicador data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
