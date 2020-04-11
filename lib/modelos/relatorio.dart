import 'dart:convert';

class Relatorio {

  int codigo;
  String periodo;
  String estado;
  String url;

  Relatorio({
    this.codigo,
    this.periodo,
    this.estado,
    this.url,
  });

  factory Relatorio.fromJson(Map<String, dynamic> map) {
    return Relatorio(
      codigo: int.parse(map["codigo"]),
      periodo: map["periodo"],
      estado: map["estado"],
      url: map["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "periodo": periodo,
      "estado": estado,
      "url": url,
    };
  }

  @override
  String toString() {
    return relatoriosToJson(this);
  }
}

List<Relatorio> relatoriosFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Relatorio>.from(data.map((item) => Relatorio.fromJson(item)));
}

String relatoriosToJson(Relatorio data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
